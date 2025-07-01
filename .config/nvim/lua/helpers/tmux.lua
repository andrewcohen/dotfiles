local M = {}

-- Open or jump to a tmux window with optional command
-- @param command string: Command to run in the new window (also used as window name)
-- @param opts table|nil: Options table with optional fields:
--   - window_name string|nil: Custom window name (defaults to command)
--   - working_dir string|nil: Working directory for the new window (defaults to current working directory)
function M.open_or_jump_to_window(command, opts)
  opts = opts or {}
  local window_name = opts.window_name or command
  local working_dir = opts.working_dir or vim.fn.getcwd()

  local windows = vim.fn.systemlist("tmux list-windows")
  local found = false

  for _, win in ipairs(windows) do
    if win:match(window_name) then
      found = true
      break
    end
  end

  if found then
    vim.fn.jobstart({ "tmux", "select-window", "-t", window_name }, { detach = true })
  else
    local cmd = {
      "tmux", "new-window",
      "-n", window_name,
      "-c", working_dir
    }

    table.insert(cmd, command)

    vim.fn.jobstart(cmd, { detach = true })
  end
end

return M
