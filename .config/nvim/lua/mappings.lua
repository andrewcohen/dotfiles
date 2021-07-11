local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- mappings

-- clear highlight on return
map('n', '<cr>', ':noh<CR><CR>', {silent = true})

map('i', 'jj', '<esc>')
map('', 'Y', 'y$')
map('v','<leader>y', '"*y')

-- telescope
map('n', '<C-p>', '<cmd>Telescope find_files<cr>')
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')
map("n", "<leader>fo", '<cmd>Telescope oldfiles<cr>')
map("n", "<leader>gt", '<cmd>Telescope git_status<cr>')
map("n", "<leader>cm", '<cmd>Telescope git_commits<cr>')

-- file tree
map('n', '<leader>n', '<cmd>NvimTreeToggle<cr>')

-- term
map('n', '<leader>t', ':ToggleTerm<cr>')

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

-- bufferline
map("n", "<S-l>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
map("n", "<S-h>", ":BufferLineCyclePrev<cr>", { noremap = true, silent = true })
map('n', '<C-x>', '<cmd>bd!<cr>', {})


-- autocomplete
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
map('i', '<C-j>', 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', {expr = true})
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<C-k>', 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', {expr = true})


map('n', '<leader>rc', '<cmd>luafile ~/.config/nvim/init.lua<cr>')

