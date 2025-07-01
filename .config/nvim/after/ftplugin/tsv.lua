vim.opt_local.expandtab   = false
vim.opt_local.tabstop     = 4
vim.opt_local.shiftwidth  = 4
vim.opt_local.softtabstop = 0

vim.opt_local.list        = true
vim.opt_local.listchars   = { tab = "⇥·" }
vim.fn.matchadd('ExtraTabChar', '\t')
vim.api.nvim_set_hl(0, 'ExtraTabChar', { fg = 'white' })
