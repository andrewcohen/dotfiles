return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = function()
      vim.cmd.colorscheme "catppuccin"
      return {
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
    end
  },
}
