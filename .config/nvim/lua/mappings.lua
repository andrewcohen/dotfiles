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

-- quickfix
map('n', '<leader>cn', '<cmd>cnext<cr>')
map('n', '<leader>cp', '<cmd>cprev<cr>')

-- open notes
map('n', '<leader>n', '<cmd>vs ~/notes.md<cr>')
map('n', '<leader>N', '<cmd>tab drop ~/notes.md<cr>')


-- tmux sessionizer
map('n', '<leader>F', '<cmd>silent !tmux neww tmux-sessionizer<CR>')

-- trouble
--
map('n', '<leader>tt', '<cmd>TroubleToggle<cr>', opts)
map('n', '<leader>tw', '<cmd>TroubleToggle workspace_diagnostics<cr>', opts)
map('n', '<leader>td', '<cmd>TroubleToggle document_diagnostics<cr>', opts)
map('n', '<leader>tq', '<cmd>TroubleToggle quickfix<cr>', opts)
map('n', '<leader>tl', '<cmd>TroubleToggle loclist<cr>', opts)

-- nnoremap gR <cmd>TroubleToggle lsp_references<cr>

-- harpoon
map('n', '<leader>h', "<cmd> lua require('harpoon.ui').toggle_quick_menu()<cr>", opts)
map('n', '<leader>m', "<cmd> lua require('harpoon.mark').add_file()<cr>", opts)

map("n", "<leader>j", "<cmd> lua require('harpoon.ui').nav_file(1)<cr>")
map("n", "<leader>k", "<cmd> lua require('harpoon.ui').nav_file(2)<cr>")
map("n", "<leader>l", "<cmd> lua require('harpoon.ui').nav_file(3)<cr>")
map("n", "<leader>;", "<cmd> lua require('harpoon.ui').nav_file(4)<cr>")

map('n', '<S-l>', "<cmd> lua require('harpoon.ui').nav_next()<cr>", opts)
map('n', '<S-h>', "<cmd> lua require('harpoon.ui').nav_prev()<cr>", opts)

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

map('n', '<leader>rc', '<cmd>luafile ~/.config/nvim/init.lua<cr>')
map('n', '<leader>ec', '<cmd>:e ~/.config/nvim/init.lua<cr>')

map('n', '<leader>M', '<cmd>:make<cr>')
map('n', '<leader>T', '<cmd>:make test<cr>')
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
