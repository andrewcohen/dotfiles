local fmt_augroup = vim.api.nvim_create_augroup("fmt", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = fmt_augroup,
  desc = "lsp formatter",
  callback = function()
    vim.api.nvim_command [[
      try | undojoin | silent! Neoformat | catch /E790/ | silent! Neoformat | endtry
    ]]
  end
})
