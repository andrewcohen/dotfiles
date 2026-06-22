local function open_float(buf, title, scale)
  scale                      = scale or 0.6
  local ui                   = vim.api.nvim_list_uis()[1]
  local width                = math.floor(scale * ui.width)
  local height               = math.floor(scale * ui.height)
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
  -- Floats created while focused in a scroll/cursor-bound window inherit those
  -- binds; clear them so scrolling the float doesn't drag other windows.
  vim.wo[win].scrollbind     = false
  vim.wo[win].cursorbind     = false


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

-- ── jj blame (fugitive-style, scroll/cursor-bound annotate gutter) ─────────
local jj_blame_state = { win = nil, buf = nil, src_win = nil }
local jj_blame_ns = vim.api.nvim_create_namespace("jjblame")

-- Theme-aware, user-overridable colours for the three gutter columns.
vim.api.nvim_set_hl(0, "JjBlameId", { link = "Identifier", default = true })
vim.api.nvim_set_hl(0, "JjBlameAuthor", { link = "Function", default = true })
vim.api.nvim_set_hl(0, "JjBlameDate", { link = "Comment", default = true })

-- Pad/truncate `s` to display width `w` (ellipsis if too long).
local function jj_blame_pad(s, w)
  if vim.fn.strdisplaywidth(s) > w then
    while vim.fn.strdisplaywidth(s) > w - 1 do
      s = vim.fn.strcharpart(s, 0, vim.fn.strchars(s) - 1)
    end
    s = s .. "…"
  end
  return s .. string.rep(" ", math.max(0, w - vim.fn.strdisplaywidth(s)))
end

local function jj_blame_clear_src()
  if jj_blame_state.src_win and vim.api.nvim_win_is_valid(jj_blame_state.src_win) then
    vim.wo[jj_blame_state.src_win].scrollbind = false
    vim.wo[jj_blame_state.src_win].cursorbind = false
  end
  jj_blame_state.win, jj_blame_state.buf, jj_blame_state.src_win = nil, nil, nil
end

local function jj_blame_close()
  local win = jj_blame_state.win
  jj_blame_clear_src()
  if win and vim.api.nvim_win_is_valid(win) then
    pcall(vim.api.nvim_win_close, win, true)
  end
end

-- Returns a handler that pops up `jj show` for the change under the cursor.
local function jj_blame_show_commit(change_ids)
  return function()
    local lnum = vim.api.nvim_win_get_cursor(0)[1]
    local cid = change_ids[lnum]
    if not cid then return end

    -- --git → standard unified diff, which the `diff` treesitter parser both
    -- highlights and injects per-file language highlighting into.
    local out = vim.fn.systemlist({ "jj", "show", "--git", "--color=never", "-r", cid })
    if vim.v.shell_error ~= 0 then
      vim.notify("jj show failed:\n" .. table.concat(out, "\n"), vim.log.levels.ERROR)
      return
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)
    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = "diff" -- FileType autocmd starts treesitter for `diff`
    local win = open_float(buf, " " .. cid .. " ", 0.8)
    vim.keymap.set("n", "q", function()
      pcall(vim.api.nvim_win_close, win, true)
    end, { buffer = buf, nowait = true, silent = true })
  end
end

local function jj_blame()
  -- Toggle: if the gutter is focused or already open, close it.
  if vim.bo.filetype == "jjblame"
      or (jj_blame_state.win and vim.api.nvim_win_is_valid(jj_blame_state.win)) then
    jj_blame_close()
    return
  end

  local path = vim.fn.expand("%:p")
  if path == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end
  local relative = vim.fn.fnamemodify(path, ":.")
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]

  -- Tab-separated columns so author names with spaces stay intact; one output
  -- line per source line (no content), in order.
  local template = table.concat({
    'commit.change_id().shortest(8)',
    [["\t"]],
    'commit.author().name()',
    [["\t"]],
    'commit.author().timestamp().local().format("%Y-%m-%d")',
    [["\n"]], -- custom annotate templates don't add a trailing newline
  }, " ++ ")

  local out = vim.fn.systemlist({ "jj", "file", "annotate", "-T", template, relative })
  if vim.v.shell_error ~= 0 then
    vim.notify("jj file annotate failed:\n" .. table.concat(out, "\n"), vim.log.levels.ERROR)
    return
  end
  local n = #out
  if n == 0 then
    vim.notify("`jj file annotate` produced no output", vim.log.levels.ERROR)
    return
  end

  -- Build a fixed-width gutter and remember each column's byte range so we can
  -- colour it after the buffer is populated.
  local id_w, author_w = 8, 14
  local display, change_ids, marks = {}, {}, {}
  for i, line in ipairs(out) do
    local id, author, date = line:match("^(.-)\t(.-)\t(.*)$")
    id = jj_blame_pad(id or "", id_w)
    local author_col = jj_blame_pad(author or "", author_w)
    local text = id .. " " .. author_col .. " " .. (date or "")
    display[i] = text
    change_ids[i] = vim.trim(line:match("^(.-)\t") or "")
    local author_start = #id + 1
    local date_start = author_start + #author_col + 1
    marks[i] = {
      { 0, #id, "JjBlameId" },
      { author_start, author_start + #author_col, "JjBlameAuthor" },
      { date_start, #text, "JjBlameDate" },
    }
  end

  local src_win = vim.api.nvim_get_current_win()
  local view = vim.fn.winsaveview() -- remember the source window's exact view
  vim.cmd("leftabove vsplit")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, display)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "jjblame"
  vim.bo[buf].modifiable = false

  for i, line_marks in ipairs(marks) do
    for _, m in ipairs(line_marks) do
      pcall(vim.api.nvim_buf_set_extmark, buf, jj_blame_ns, i - 1, m[1],
        { end_col = m[2], hl_group = m[3] })
    end
  end

  local width = 0
  for _, l in ipairs(display) do width = math.max(width, vim.fn.strdisplaywidth(l)) end
  vim.api.nvim_win_set_width(win, math.min(width + 1, math.floor(vim.o.columns * 0.5)))

  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].foldcolumn = "0"
  vim.wo[win].wrap = false
  vim.wo[win].winfixwidth = true
  vim.wo[win].cursorline = true

  -- Match the gutter to the source's view *before* binding so neither window
  -- jumps; scrollbind then just keeps them locked from this aligned start.
  vim.fn.winrestview({ topline = view.topline, lnum = math.min(cur_line, n), col = 0, leftcol = 0 })
  vim.wo[win].scrollbind = true
  vim.wo[win].cursorbind = true
  vim.wo[src_win].scrollbind = true
  vim.wo[src_win].cursorbind = true

  jj_blame_state.win, jj_blame_state.buf, jj_blame_state.src_win = win, buf, src_win

  for _, key in ipairs({ "q", "gq", "<Esc>" }) do
    vim.keymap.set("n", key, jj_blame_close, { buffer = buf, silent = true, nowait = true })
  end
  vim.keymap.set("n", "<CR>", jj_blame_show_commit(change_ids),
    { buffer = buf, silent = true, nowait = true, desc = "jj show this change" })

  -- If the gutter window goes away by any other means, drop the scroll/cursor bind.
  vim.api.nvim_create_autocmd("WinClosed", {
    pattern = tostring(win),
    once = true,
    callback = jj_blame_clear_src,
  })
end

vim.api.nvim_create_user_command("JJBlame", jj_blame, {})
vim.keymap.set("n", "<leader>gb", jj_blame, { desc = "jj blame (annotate)", silent = true })

-- ── jj browse (fugitive :GBrowse replacement — open file/line on GitHub) ───
local function git_remote_to_https(url)
  url = url:gsub("%.git$", "")
  local host, path = url:match("^git@([^:]+):(.+)$") -- git@github.com:owner/repo
  if host then return "https://" .. host .. "/" .. path end
  host, path = url:match("^ssh://git@([^/]+)/(.+)$") -- ssh://git@github.com/owner/repo
  if host then return "https://" .. host .. "/" .. path end
  if url:match("^https?://") then return (url:gsub("^(https?://)[^@/]*@", "%1")) end
  return nil
end

local function jj_browse(line1, line2)
  local path = vim.fn.expand("%:p")
  if path == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end

  -- Path relative to the (workspace) repo root, with forward slashes.
  local root = vim.fn.systemlist({ "jj", "root" })[1]
  local relative
  if root and path:sub(1, #root + 1) == root .. "/" then
    relative = path:sub(#root + 2)
  else
    relative = vim.fn.fnamemodify(path, ":.")
  end

  -- Pick the origin remote (or the first one) and normalise to an https URL.
  local remote_url
  for _, line in ipairs(vim.fn.systemlist({ "jj", "git", "remote", "list" })) do
    local name, url = line:match("^(%S+)%s+(%S+)")
    if name == "origin" then
      remote_url = url
      break
    end
    remote_url = remote_url or url
  end
  local base = remote_url and git_remote_to_https(remote_url)
  if not base then
    vim.notify("Could not determine a GitHub remote URL", vim.log.levels.ERROR)
    return
  end

  -- Link to the nearest pushed ancestor so the URL never 404s on an
  -- unpushed working-copy commit; fall back to @ if nothing is pushed yet.
  local commit = vim.fn.systemlist({ "jj", "log", "--no-graph", "--ignore-working-copy",
    "-r", "latest(::@ & remote_bookmarks())", "-T", "commit_id" })[1]
  if not commit or commit == "" then
    commit = vim.fn.systemlist({ "jj", "log", "--no-graph", "-r", "@", "-T", "commit_id" })[1]
  end

  local frag = ""
  if line1 then
    frag = "#L" .. line1
    if line2 and line2 ~= line1 then frag = frag .. "-L" .. line2 end
  end
  local url = base .. "/blob/" .. commit .. "/" .. relative .. frag

  vim.fn.setreg("+", url)
  local opened = pcall(vim.ui.open, url)
  vim.notify((opened and "Opened (and copied) " or "Copied ") .. url)
end

vim.api.nvim_create_user_command("JJBrowse", function(o)
  -- Only anchor to lines when invoked with an explicit range (e.g. visual).
  if o.range > 0 then
    jj_browse(o.line1, o.line2)
  else
    jj_browse(nil, nil)
  end
end, { range = true })
vim.keymap.set("n", "<leader>gB", function()
  jj_browse(nil, nil) -- no selection → link to the file, no line anchor
end, { desc = "jj browse file on GitHub", silent = true })
vim.keymap.set("x", "<leader>gB", function()
  local a, b = vim.fn.line("v"), vim.fn.line(".")
  jj_browse(math.min(a, b), math.max(a, b))
end, { desc = "jj browse selection on GitHub", silent = true })

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
