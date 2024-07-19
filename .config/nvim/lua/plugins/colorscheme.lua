return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = "macchiato",
        -- transparent_background = true,
        integrations = {
          cmp = true,
          dap = {
            enabled = true,
            enable_ui = true, -- enable nvim-dap-ui
          },
          gitsigns = true,
          harpoon = true,
          lsp_trouble = true,
          indent_blankline = {
            enabled = true,
            scope_color = "overlay0"
          },
          markdown = true,
          mason = true,
          neogit = true,
          telescope = true,
          treesitter = true,
          treesitter_context = true,
          which_key = true,
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
      }
      vim.cmd.colorscheme "catppuccin"
    end
  },
}
