return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- after = 'onedark.nvim',
    config = function()
      local extend_sections = {
        lualine_a = {
          'filetype',
        },
      }

      local dapui = {
        sections = extend_sections,
        filetypes = {
          -- ['dapui_scopes'] = 'DAP Scopes',
          -- ['dapui_stacks'] = 'DAP Stacks',
          -- ['dapui_breakpoints'] = 'DAP Breakpoints',
          -- ['dapui_watches'] = 'DAP Watches',

          'dapui_scopes',
          'dapui_stacks',
          'dapui_breakpoints',
          'dapui_watches',
        },
      }
      require('lualine').setup {
        options = {
          theme = "catppuccin",
          component_separators = '|',
          section_separators = { left = '', right = '' },
          extensions = { dapui },
          -- disabled_filetypes = {
          --   'dapui_scopes',
          --   'dapui_stacks',
          --   'dapui_breakpoints',
          --   'dapui_watches',
          -- }
        },
        sections = {
          lualine_b = { 'branch', 'diff',
            { 'diagnostics', symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' } }
          },
        }
        -- ['dapui_scopes'] = 'DAP Scopes',
        -- ['dapui_stacks'] = 'DAP Stacks',
        -- ['dapui_breakpoints'] = 'DAP Breakpoints',
        -- ['dapui_watches'] = 'DAP Watches',
      }
    end
  },

  -- lazy.nvim
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      input = {
        enabled = true,
      },
      picker = { enabled = true },
      styles = {
        input = {
          relative = 'cursor',
          row = -4,
          col = 0
        }
      }
    }
  },
  {
    'j-hui/fidget.nvim',
    opts = {}
  },
}
