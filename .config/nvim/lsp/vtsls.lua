return {
  -- root_dir = require('lspconfig.util').root_pattern('tsconfig.json', 'package.json'),
  settings = {
    typescript = {
      preferences = {
        -- importModuleSpecifier = "non-relative", -- prevents ./../ imports
      },
    },
  },
  on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", "", {
      silent = true,
      callback = function()
        vim.lsp.buf.code_action({
          apply = true,
          context = {
            only = { "source.removeUnusedImports" },
            diagnostics = {},
          },
        })
      end,
    })
  end,
}
