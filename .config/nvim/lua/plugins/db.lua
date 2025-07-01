-- Fixed-width (header + dashed ruler + rows) -> CSV or JSON (with type inference).
-- Usage:
--   :FixedTableExport csv
--   :FixedTableExport json

local M = {}

-- ---------- ruler-based parsing ----------
local function is_ruler(line)
  if not line or line == "" then return false end
  -- Original ruler detection
  if line:find("%-") and line:match("^[%-%s|]+$") then return true end
  return false
end


local function find_header_and_ruler(lines)
  local header_idx, ruler_idx
  for i = 1, #lines do
    local t = vim.trim(lines[i] or "")
    if t ~= "" then
      header_idx = i
      -- find next non-empty line; if it's a ruler, use it
      for j = i + 1, #lines do
        local tj = vim.trim(lines[j] or "")
        if tj ~= "" then
          if is_ruler(lines[j]) then
            ruler_idx = j
          end
          break
        end
      end
      break
    end
  end
  return header_idx, ruler_idx
end

local function column_spans_from_ruler(ruler)
  -- Return { {s1,e1}, ... } (1-based inclusive)
  local spans = {}
  local i, n = 1, #ruler
  while i <= n do
    if ruler:sub(i, i) == "-" then
      local s = i
      repeat i = i + 1 until i > n or ruler:sub(i, i) ~= "-"
      table.insert(spans, { s, i - 1 })
    else
      i = i + 1
    end
  end
  return spans
end

local function slice_fixed(line, s, e)
  local n = #line
  if s > n then return "" end
  if e > n then e = n end
  return vim.trim(line:sub(s, e))
end

local function dedupe_headers(headers)
  local seen, out = {}, {}
  for i, h in ipairs(headers) do
    local key = (h == "" and ("col_" .. i)) or h
    local base, k = key, key
    local idx = 2
    while seen[k] do
      k = base .. "_" .. idx
      idx = idx + 1
    end
    seen[k] = true
    table.insert(out, k)
  end
  return out
end

local function parse_with_ruler(lines)
  local header_idx, ruler_idx = find_header_and_ruler(lines)
  if not header_idx or not ruler_idx then
    return {}, {}
  end
  local spans = column_spans_from_ruler(lines[ruler_idx])
  if #spans == 0 then return {}, {} end

  -- header
  local raw_header = {}
  for _, span in ipairs(spans) do
    table.insert(raw_header, slice_fixed(lines[header_idx], span[1], span[2]))
  end
  local header = dedupe_headers(raw_header)

  -- rows
  local rows = {}
  for i = ruler_idx + 1, #lines do
    local line = lines[i]
    if line and vim.trim(line) ~= "" and not is_ruler(line) then
      local row = {}
      for ci, span in ipairs(spans) do
        row[ci] = slice_fixed(line, span[1], span[2])
      end
      table.insert(rows, row)
    end
  end

  return header, rows
end

-- ---------- CSV ----------
local function csv_escape(cell)
  if cell:find('[,"\n]') then
    cell = '"' .. cell:gsub('"', '""') .. '"'
  end
  return cell
end

local function to_csv(header, rows)
  local out = {}

  local h = {}
  for _, k in ipairs(header) do table.insert(h, csv_escape(k)) end
  table.insert(out, table.concat(h, ","))

  for _, r in ipairs(rows) do
    local line = {}
    for i = 1, #header do
      table.insert(line, csv_escape(tostring(r[i] or "")))
    end
    table.insert(out, table.concat(line, ","))
  end

  return table.concat(out, "\n")
end

-- ---------- JSON with type inference ----------
local function infer_primitive(s)
  -- Treat empty string as null
  if s == nil then return vim.NIL end
  local trimmed = vim.trim(s)
  if trimmed == "" then return vim.NIL end

  -- booleans (case-insensitive)
  if trimmed:match("^[Tt][Rr][Uu][Ee]$") then return true end
  if trimmed:match("^[Ff][Aa][Ll][Ss][Ee]$") then return false end

  -- integers
  if trimmed:match("^%-?%d+$") then
    local n = tonumber(trimmed)
    if n then return n end
  end

  -- floats (supports "6.00", "-0.5", "1e3", "1.2E-3")
  if trimmed:match("^%-?%d+%.%d+$") or trimmed:match("^%-?%d+%.?%d*[eE][%+%-]?%d+$") then
    local n = tonumber(trimmed)
    if n then return n end
  end

  -- keep timestamps/dates as strings (time zone unknown)
  -- Example matches like "2025-05-12 08:54:44.000" or "2025-05-13 04:00:00.000"
  -- If you want these coerced/normalized, we can add an opt-in later.

  -- fallback to string
  return trimmed
end

local function json_escape_string(s)
  return (s
    :gsub("\\", "\\\\")
    :gsub('"', '\\"')
    :gsub("\b", "\\b")
    :gsub("\f", "\\f")
    :gsub("\n", "\\n")
    :gsub("\r", "\\r")
    :gsub("\t", "\\t"))
end

local function to_json_value(v)
  local t = type(v)
  if v == vim.NIL then
    return "null"
  elseif t == "number" then
    return tostring(v)
  elseif t == "boolean" then
    return v and "true" or "false"
  else
    return '"' .. json_escape_string(tostring(v)) .. '"'
  end
end

local function to_json(header, rows)
  local pieces = { "[" }
  for ri, r in ipairs(rows) do
    local fields = {}
    for i = 1, #header do
      local key = json_escape_string(header[i] or ("col_" .. i))
      local val = infer_primitive(r[i])
      table.insert(fields, string.format('  "%s": %s', key, to_json_value(val)))
    end
    local obj = "{\n" .. table.concat(fields, ",\n") .. "\n}"
    if ri < #rows then obj = obj .. "," end
    table.insert(pieces, obj)
  end
  table.insert(pieces, "]")
  return table.concat(pieces, "\n")
end

-- ---------- buffer output ----------
local function write_to_new_buffer(text, filetype)
  vim.cmd("enew")
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.split(text, "\n", { plain = true })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].buftype = ""
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = filetype
end

-- ---------- command ----------
function M.export(format)
  format = (format or ""):lower()
  if format ~= "csv" and format ~= "json" then
    vim.notify("FixedTableExport: specify 'csv' or 'json'", vim.log.levels.ERROR)
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local header, rows = parse_with_ruler(lines)

  if #header == 0 then
    vim.notify("FixedTableExport: could not detect header/ruler layout", vim.log.levels.ERROR)
    return
  end

  if format == "csv" then
    write_to_new_buffer(to_csv(header, rows), "csv")
  else
    write_to_new_buffer(to_json(header, rows), "json")
  end
end

vim.api.nvim_create_user_command("FixedTableExport", function(opts)
  M.export(opts.args)
end, {
  nargs = 1,
  complete = function() return { "csv", "json" } end,
})



return {
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod',                     lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
      -- for redshift
      vim.g.db_ui_use_postgres_views = 0
    end,
    keys = {
      { "<leader>da", "<cmd>DBUIToggle<cr>", desc = "open dbui (dadbod)" }
    }
  },
}
