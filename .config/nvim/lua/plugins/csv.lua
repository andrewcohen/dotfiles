-- Simple CSV to JSON converter for 2-column CSV files
-- Converts CSV with key-value pairs to JSON object, discarding header

-- Parse a CSV line into fields, handling quoted values
local function parse_csv_line(line)
  local fields = {}
  local field = ""
  local in_quotes = false
  local i = 1

  while i <= #line do
    local char = line:sub(i, i)

    if char == '"' then
      if in_quotes and i < #line and line:sub(i + 1, i + 1) == '"' then
        -- Escaped quote
        field = field .. '"'
        i = i + 1
      else
        in_quotes = not in_quotes
      end
    elseif char == ',' and not in_quotes then
      table.insert(fields, field)
      field = ""
    else
      field = field .. char
    end

    i = i + 1
  end

  table.insert(fields, field)
  return fields
end

-- Escape string for JSON
local function json_escape(str)
  return str:gsub("\\", "\\\\")
      :gsub('"', '\\"')
      :gsub("\n", "\\n")
      :gsub("\r", "\\r")
      :gsub("\t", "\\t")
end

-- Try to parse value as number, boolean, or keep as string
local function parse_value(value)
  local trimmed = vim.trim(value)

  -- Check for boolean values (case-insensitive)
  if trimmed:lower() == "true" then
    return true
  elseif trimmed:lower() == "false" then
    return false
  end

  -- Check for numbers (integer or float)
  local num = tonumber(trimmed)
  if num then
    return num
  end

  -- Return as string if not a number or boolean
  return trimmed
end

-- Convert value to JSON representation
local function value_to_json(value)
  local t = type(value)
  if t == "number" then
    return tostring(value)
  elseif t == "boolean" then
    return value and "true" or "false"
  else
    return '"' .. json_escape(tostring(value)) .. '"'
  end
end

-- Convert current buffer from CSV to JSON
local function csv_to_json()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  if #lines < 2 then
    vim.notify("CSV file must have at least a header and one data row", vim.log.levels.ERROR)
    return
  end

  local json_pairs = {}

  -- Skip the first line (header) and process the rest
  for i = 2, #lines do
    local line = vim.trim(lines[i])
    if line ~= "" then
      local fields = parse_csv_line(line)

      if #fields >= 2 then
        local key = vim.trim(fields[1])
        local raw_value = vim.trim(fields[2])
        local value = parse_value(raw_value)

        -- Remove surrounding quotes if present
        if key:match('^".*"$') then
          key = key:sub(2, -2):gsub('""', '"')
        end
        if type(value) == "string" and value:match('^".*"$') then
          value = value:sub(2, -2):gsub('""', '"')
        end

        table.insert(json_pairs, string.format('  "%s": %s', json_escape(key), value_to_json(value)))
      end
    end
  end

  if #json_pairs == 0 then
    vim.notify("No valid key-value pairs found in CSV", vim.log.levels.ERROR)
    return
  end

  -- Create JSON object
  local json_content = "{\n" .. table.concat(json_pairs, ",\n") .. "\n}"

  -- Create new buffer with JSON content
  vim.cmd("enew")
  local new_buf = vim.api.nvim_get_current_buf()
  local json_lines = vim.split(json_content, "\n", { plain = true })
  vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, json_lines)
  vim.bo[new_buf].filetype = "json"
  vim.bo[new_buf].buftype = "nofile"
  vim.bo[new_buf].bufhidden = "hide"
  vim.bo[new_buf].swapfile = false
  vim.bo[new_buf].modified = false

  vim.notify("CSV converted to JSON successfully", vim.log.levels.INFO)
end

-- Create user command
vim.api.nvim_create_user_command("CsvToJson", function()
  csv_to_json()
end, {
  desc = "Convert current CSV buffer to JSON (2-column key-value pairs, discarding header)"
})

return {}
