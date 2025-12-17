return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = "macchiato",
        -- transparent_background = true,
        custom_highlights = function(colors)
          return {
            DapBreakpoint = { fg = colors.mauve },
            DapBreakpointCondition = { fg = colors.yellow },
            DapLogPoint = { fg = colors.sapphire },
            DapStopped = { fg = colors.green },
            DapBreakpointRejected = { fg = colors.red },
          }
        end,
        integrations = {
          blink_cmp = true,
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
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
            },
          },
          neogit = true,
          telescope = true,
          treesitter = true,
          treesitter_context = true,
          which_key = true,
        },
      }
      vim.cmd.colorscheme "catppuccin"
    end
  },
}
