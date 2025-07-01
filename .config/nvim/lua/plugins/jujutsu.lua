local function open_float(buf, title)
  local ui                   = vim.api.nvim_list_uis()[1]
  local width                = math.floor((0.6) * ui.width)
  local height               = math.floor((0.6) * ui.height)
  local win                  = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((ui.width - width) / 2),
    row = math.floor((ui.height - height) / 2),
    border = "rounded",
    style = "minimal",
    noautocmd = true,
    zindex = 50,
    title = title
  })

  vim.wo[win].number         = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn     = "no"
  vim.wo[win].cursorline     = false
  vim.wo[win].wrap           = false


  vim.keymap.set("n", "<Esc>", function()
    pcall(vim.api.nvim_win_close, win, true)
  end, { buffer = buf, nowait = true, silent = true })

  return win
end


local function jj_edit_desc()
  local buf             = vim.api.nvim_create_buf(false, true) -- listed=false, scratch=true

  vim.bo[buf].buftype   = "acwrite"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile  = false
  vim.bo[buf].filetype  = 'jjdesc'

  vim.api.nvim_buf_set_name(buf, "JJ:description")

  local win = open_float(buf, "JJ:description")
  -- vim.cmd("tabnew")
  -- vim.api.nvim_win_set_buf(0, buf)

  local desc = vim.fn.systemlist({ "jj", "log", "-T", "description", "--no-graph", "--color=never",
    "--ignore-working-copy", "-r", "@" })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, desc)

  vim.api.nvim_create_autocmd("BufWriteCmd", {
    buffer = buf,
    callback = function(args)
      local lines  = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
      local text   = table.concat(lines, "\n")

      local result = vim.system({ "jj", "describe", "--stdin", "--no-edit" }, { stdin = text }):wait()
      if result.code ~= 0 then
        vim.notify("jj describe failed:\n" .. (result.stderr or ""), vim.log.levels.ERROR)
        return
      end

      vim.notify("JJ description updated ✅")
      vim.cmd("bd!")
    end,
  })
end


local function jj_log()
  -- Toggle: if a jjlog terminal is visible, close it
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local b = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_is_loaded(b)
        and vim.bo[b].buftype == "terminal"
        and vim.bo[b].filetype == "jjlog" then
      vim.api.nvim_win_close(win, true)
      return
    end
  end

  -- Remember current window, open a vsplit, and make it current
  local prev_win = vim.api.nvim_get_current_win()
  vim.cmd("vsplit")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(win, math.max(20, math.floor(vim.o.columns * 0.30)))
  vim.wo[win].winfixwidth = true

  -- Ensure the split has a fresh, unnamed buffer and set simple opts
  vim.cmd("enew")
  local buf             = vim.api.nvim_get_current_buf()
  vim.bo[buf].filetype  = "jjlog"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile  = false

  -- START the terminal job IN THIS WINDOW
  -- Use env.PAGER so jj uses less; no shell needed
  local jid             = vim.fn.jobstart(
    { "jj", "log", "-r", "::@" }, -- adjust revset as you like
    {
      term    = true,             -- ← attach a real terminal to *current* window
      env     = { PAGER = "less -R" },
      on_exit = function(_, _)
        if vim.api.nvim_win_is_valid(win) then
          vim.schedule(function() pcall(vim.api.nvim_win_close, win, true) end)
        end
      end,
    }
  )
  if jid <= 0 then
    vim.notify("Failed to start `jj log` terminal", vim.log.levels.ERROR)
    -- go back to previous window if something failed
    if vim.api.nvim_win_is_valid(prev_win) then vim.api.nvim_set_current_win(prev_win) end
    return
  end

  -- drop into terminal-mode so less receives keys
  vim.cmd("startinsert")
end


local function load_jj_conflicts_to_qf()
  -- Run jj status to get conflicted files
  local handle = io.popen("jj status | grep '2-sided conflict' | awk '{print $1}'")
  if not handle then return end
  local result = handle:read("*a")
  handle:close()

  -- Table to store quickfix items
  local qf_list = {}

  -- Process each conflicted file
  for file in result:gmatch("[^\r\n]+") do
    local conflict_file = io.open(file, "r")
    if conflict_file then
      local line_num = 0
      local in_conflict = false
      local conflict_text = {}

      for line in conflict_file:lines() do
        line_num = line_num + 1

        if line:match("^<<<<<<<") then
          in_conflict = true
          conflict_text = { line } -- Start a new conflict block
        elseif line:match("^>>>>>>>") and in_conflict then
          table.insert(conflict_text, line)
          local text = table.concat(conflict_text, " | ") -- Concatenate for quickfix display

          -- Add to quickfix list
          table.insert(qf_list, {
            filename = file,
            lnum = line_num - #conflict_text + 1, -- Start line of the conflict
            col = 1,
            text = text
          })

          in_conflict = false
        elseif in_conflict then
          table.insert(conflict_text, line)
        end
      end
      conflict_file:close()
    end
  end

  -- Load conflicts into the quickfix list
  if #qf_list > 0 then
    vim.fn.setqflist(qf_list, "r") -- Replace quickfix list
    vim.cmd("copen")               -- Open quickfix window
  else
    print("No Jujutsu conflicts found!")
  end
end

require("which-key").add({
  { "<leader>j",  group = "Jujutsu (jj)" },
  { "<leader>jd", jj_edit_desc,          desc = "Edit JJ description" },
  { "<leader>jl", jj_log,                desc = "JJ log" },
  { "<leader>js", "<Cmd>!jj squash<CR>", desc = "Squash current change" },
  {
    "<leader>jn",
    function()
      vim.fn.jobstart({ "jj", "new" }, {
        detach = true, -- let it run independently
        stdout_buffered = false,
        on_stdout = function() end,
        on_stderr = function() end,
      })
    end,
    desc = "new changeset",
    silent = true
  },
  { "<leader>jc", load_jj_conflicts_to_qf, desc = "JJ Conflicts" },
}, { prefix = "<leader>" })


-- Create a Neovim command
vim.api.nvim_create_user_command("JJConflicts", load_jj_conflicts_to_qf, {})

vim.keymap.set("n", "<leader>J", function()
  require("helpers.tmux").open_or_jump_to_window("jjui")
end, { desc = "Open or jump to jjui in tmux" })

return {
  {
    "julienvincent/hunk.nvim",
    dependencies = { 'MunifTanjim/nui.nvim' },
    cmd = { "DiffEditor" },
    config = function()
      require("hunk").setup()
    end,
  },

  { 'rafikdraoui/jj-diffconflicts' },
  {
    'algmyr/vcmarkers.nvim',
    keys = {
      { '<leader>ms', function() require('vcmarkers').actions.select_section(0) end, desc = "Accept selection" }
    }
  }
}
