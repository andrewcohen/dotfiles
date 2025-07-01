local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- mappings

local opts = { noremap = true, silent = true }

-- clear highlight on return
map('n', '<cr>', ':noh<CR><CR>', { silent = true })

map('i', 'jj', '<esc>')
map('', 'Y', 'y$')
map('v', '<leader>y', '"*y')

-- move visual lines up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- quickfix
map('n', '<leader>cn', '<cmd>cnext<cr>')
map('n', '<leader>cp', '<cmd>cprev<cr>')

local function toggle_notes()
  local notes_path = vim.fn.expand("~/notes.md")
  local notes_bufnr = vim.fn.bufnr(notes_path)

  -- Check if notes buffer exists and is loaded
  if notes_bufnr ~= -1 and vim.api.nvim_buf_is_loaded(notes_bufnr) then
    -- Check all windows for the notes buffer
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == notes_bufnr and vim.api.nvim_win_is_valid(win) then
        -- Notes is visible, close the window
        vim.api.nvim_win_close(win, false)
        return
      end
    end
  end

  -- Notes not visible, open in vertical split
  -- Open in horizontal split at 30% height
  local height = math.floor(vim.o.lines * 0.3)
  vim.cmd("split " .. notes_path)
  vim.cmd("resize " .. height)
  vim.cmd("$") -- scroll to bottom
end

-- open notes
vim.keymap.set('n', '<leader>n', toggle_notes, { desc = "Toggle notes" })
map('n', '<leader>N', '<cmd>tab drop ~/notes.md<cr>')


-- tmux sessionizer
map('n', '<leader>F', '<cmd>silent !tmux neww tms<CR>')

-- tmux test runner with custom window name
vim.keymap.set("n", "<leader>T", function()
  local command = "bash -c 'CI=1 pnpm vitest; read -p \"Press Enter to close...\"'"
  require("helpers.tmux").open_or_jump_to_window(command, {
    window_name = "pnpm test"
  })
end, { desc = "Run tests in tmux" })

vim.keymap.set("n", "<leader>tt", function()
  local current_file = vim.fn.expand("%")
  local test_file

  if current_file:match("%.test%.ts$") then
    test_file = current_file                       -- Already a test file
  else
    test_file = vim.fn.expand("%:r") .. ".test.ts" -- Remove extension and add .test.ts
  end

  local command = "bash -c 'CI=1 pnpm vitest --allowOnly " .. test_file .. "; read -p \"Press Enter to close...\"'"
  require("helpers.tmux").open_or_jump_to_window(command, {
    window_name = "pnpm test"
  })
end, { desc = "Run tests for current file in tmux" })


-- nnoremap gR <cmd>TroubleToggle lsp_references<cr>

-- harpoon
-- map('n', '<leader>h', "<cmd> lua require('harpoon.ui').toggle_quick_menu()<cr>", opts)
-- map('n', '<leader>m', "<cmd> lua require('harpoon.mark').add_file()<cr>", opts)

-- map("n", "<leader>j", "<cmd> lua require('harpoon.ui').nav_file(1)<cr>")
-- map("n", "<leader>k", "<cmd> lua require('harpoon.ui').nav_file(2)<cr>")
-- map("n", "<leader>l", "<cmd> lua require('harpoon.ui').nav_file(3)<cr>")
-- map("n", "<leader>;", "<cmd> lua require('harpoon.ui').nav_file(4)<cr>")

-- map('n', '<S-l>', "<cmd> lua require('harpoon.ui').nav_next()<cr>", opts)
-- map('n', '<S-h>', "<cmd> lua require('harpoon.ui').nav_prev()<cr>", opts)

-- git
vim.api.nvim_command([[
function! s:ToggleBlame()
    if &l:filetype ==# 'fugitiveblame'
        :normal gq
    else
        Git blame
    endif
endfunction
nnoremap <leader>gb :call <SID>ToggleBlame()<CR>
]])

map('n', '<leader>gl', ':Git log<CR>', opts)
map('n', '<leader>G', ':Git<CR>', opts)
map('n', '<leader>gco', ':Git checkout ', { silent = false })

map('n', '<leader>rc', '<cmd>luafile ~/.config/nvim/init.lua<cr>')
map('n', '<leader>ec', '<cmd>:e ~/.config/nvim/init.lua<cr>')

map('n', '<leader>M', '<cmd>:make<cr>')
-- map('n', '<leader>mr', '<cmd>:make run<cr>')

-- debugger
vim.keymap.set('n', '<leader>b', "<Cmd>lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set('n', '<leader>B', "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set('n', '<leader>lp',
  "<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
vim.keymap.set('n', '<leader>dc', "<Cmd>lua require'dap'.continue()<CR>")
vim.keymap.set('n', '<leader>do', "<Cmd>lua require'dap'.step_over()<CR>")
vim.keymap.set('n', '<leader>di', "<Cmd>lua require'dap'.step_into()<CR>")
vim.keymap.set('n', '<leader>dI', "<Cmd>lua require'dap'.step_out()<CR>")
vim.keymap.set('n', '<leader>du', "<Cmd>lua require'dapui'.toggle()<CR>")
vim.keymap.set('n', '<leader>dS', "<Cmd>lua require'dap'.disconnect()<CR>")

-- terminal  escape
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')


local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

return {
  set_normal_mappings = function()
    vim.keymap.set('n', 'c', "<Cmd>lua require'dap'.continue()<CR>")
    vim.keymap.set('n', 'o', "<Cmd>lua require'dap'.step_over()<CR>")
    vim.keymap.set('n', 'i', "<Cmd>lua require'dap'.step_into()<CR>")
    vim.keymap.set('n', 'I', "<Cmd>lua require'dap'.step_out()<CR>")
    vim.keymap.set('n', 'S', "<Cmd>lua require'dap'.disconnect()<CR>")
  end,
  unset_normal_mappings = function()
    vim.cmd [[silent! unmap c]]
    vim.cmd [[silent! unmap o]]
    vim.cmd [[silent! unmap i]]
    vim.cmd [[silent! unmap I]]
    vim.cmd [[silent! unmap S]]
  end
}
