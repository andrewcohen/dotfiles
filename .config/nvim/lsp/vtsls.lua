vim.lsp.config('vtsls', {
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

    -- -- neoformat uses prettier unlike the lsp
    -- client.server_capabilities.documentFormattingProvider = false
    -- client.server_capabilities.documentRangeFormattingProvider = false

    -- vim.api.nvim_create_autocmd("BufWritePre", {
    --   desc = "lsp formatter",
    --   callback = function()
    --     vim.api.nvim_command [[silent! Neoformat]]
    --   end
    -- })
  end,
})
