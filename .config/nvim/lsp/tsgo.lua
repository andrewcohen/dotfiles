vim.lsp.config('tsgo', {
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", "",
      {
        silent = true,
        callback = function()
          vim.lsp.buf.code_action({
            apply = true,
            context = {
              only = { "source.removeUnusedImports" },
              diagnostics = {},
            },
          })
        end
      })
  end,
})
