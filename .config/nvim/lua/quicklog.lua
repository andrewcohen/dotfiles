local M = {}

local prefix = '- '
local time_format = '%Y-%m-%d %H:%M'

local function ensure_parent_dir(path)
  local dir = vim.fn.fnamemodify(path, ':h')
  if dir ~= '' and vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, 'p')
  end
end

local function expand(path)
  return vim.fn.expand(path)
end

local function build_line(description)
  local ts = os.date(time_format)
  local line = string.format('%s%s %s', prefix, ts, description)
  return line
end

local function append_line(path, line)
  ensure_parent_dir(path)
  vim.fn.writefile({ line }, path, 'a')
end

local function bottom_input(opts, on_confirm)
  vim.fn.inputsave()
  local answer = vim.fn.input(opts.prompt or '', opts.default or '')
  vim.fn.inputrestore()
  on_confirm(answer)
end

function M.add_entry()
  local file = expand(M.opts.filepath)
  bottom_input({ prompt = 'Quicklog: ' }, function(description)
    if not description or description == '' then
      vim.notify('QuickLog: empty description, aborted.', vim.log.levels.WARN)
      return
    end
    local line = build_line(description)
    append_line(file, line)
    vim.notify('QuickLog: appended to ' .. file, vim.log.levels.INFO)
  end)
end

function M.setup(opts)
  M.opts = opts

  vim.api.nvim_create_user_command('QuickLog', function()
    M.add_entry()
  end, { desc = 'Prompt for description and append to quicklog file' })

  vim.api.nvim_create_user_command('QuickLogOpen', function()
    M.open()
  end, { desc = 'Open quicklog file in floating window' })

  vim.keymap.set('n', '<leader>qn', M.add_entry, { desc = 'Prompt for description and append to quicklog file' })
end

-- vim.keymap.set('n', '<leader>qn', ':QuickLog<CR>')
-- vim.keymap.set('n', '<leader>ql', '<cmd>! cat ' .. filepath .. '<cr>', 'Log contents of quicklog file')

return M
