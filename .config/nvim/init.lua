local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local execute = vim.api.nvim_command

vim.api.nvim_set_keymap('n', '<SPACE>', '<Nop>', {})
vim.g.mapleader = " "
vim.opt.termguicolors = true

require('plugins')
require('options')
require('mappings')
require('plugins.bufferline')

cmd [[colorscheme onedark]]

-- enable mouse scroll
execute('set mouse=a')

execute([[
autocmd BufLeave,FocusLost * silent! wall  " Save anytime we leave a buffer or MacVim loses focus.
autocmd BufWritePre * undojoin | Neoformat
autocmd BufWritePre * :%s/\s\+$//e " strip trailing whitespace on save
]])

