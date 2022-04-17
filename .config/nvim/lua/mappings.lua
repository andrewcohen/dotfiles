local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- mappings

local opts = { noremap = true, silent = true }

-- clear highlight on return
map('n', '<cr>', ':noh<CR><CR>', {silent = true})

map('i', 'jj', '<esc>')
map('', 'Y', 'y$')
map('v','<leader>y', '"*y')

-- open notes
map('n', '<leader>n', '<cmd>e ~/notes.md<cr>')

-- telescope
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
map('n', '<leader>fw', '<cmd>Telescope grep_string<cr>')
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')
map("n", "<leader>fo", '<cmd>Telescope oldfiles<cr>')
map("n", "<leader>gt", '<cmd>Telescope git_status<cr>')
map("n", "<leader>cm", '<cmd>Telescope git_commits<cr>')


-- trouble
--
map('n', '<leader>tt', '<cmd>TroubleToggle<cr>', opts)
map('n', '<leader>tw', '<cmd>TroubleToggle workspace_diagnostics<cr>', opts)
map('n', '<leader>td', '<cmd>TroubleToggle document_diagnostics<cr>', opts)
map('n', '<leader>tq', '<cmd>TroubleToggle quickfix<cr>', opts)
map('n', '<leader>tl', '<cmd>TroubleToggle loclist<cr>', opts)
-- nnoremap gR <cmd>TroubleToggle lsp_references<cr>

-- breakout of terminal with window movements
vim.api.nvim_command([[
tnoremap <c-w>j <c-\><c-n><c-w>j
tnoremap <c-w>k <c-\><c-n><c-w>k
tnoremap <c-w>h <c-\><c-n><c-w>h
noremap <c-w>l <c-\><c-n><c-w>l
noremap <c-w>J <c-\><c-n><c-w>J
tnoremap <c-w>K <c-\><c-n><c-w>K
tnoremap <c-w>H <c-\><c-n><c-w>H
tnoremap <c-w>L <c-\><c-n><c-w>L
tnoremap <c-w>x <c-\><c-n><c-w>x
]])


-- harpoon
map('n', '<leader>h',"<cmd> lua require('harpoon.ui').toggle_quick_menu()<cr>", opts)
map('n', '<leader>m',"<cmd> lua require('harpoon.mark').add_file()<cr>", opts)

map("n", "<leader>j", "<cmd> lua require('harpoon.ui').nav_file(1)<cr>")
map("n", "<leader>k", "<cmd> lua require('harpoon.ui').nav_file(2)<cr>")
map("n", "<leader>l", "<cmd> lua require('harpoon.ui').nav_file(3)<cr>")
map("n", "<leader>;", "<cmd> lua require('harpoon.ui').nav_file(4)<cr>")

map('n', '<S-l>',"<cmd> lua require('harpoon.ui').nav_next()<cr>", opts)
map('n', '<S-h>',"<cmd> lua require('harpoon.ui').nav_prev()<cr>", opts)

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

map('n', '<leader>rc', '<cmd>luafile ~/.config/nvim/init.lua<cr>')

