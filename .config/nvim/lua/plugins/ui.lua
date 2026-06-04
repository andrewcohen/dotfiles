return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'catppuccin/nvim',
    },
    -- after = 'onedark.nvim',
    config = function()
      -- Cached async jj description: io.popen here blocked the UI on every
      -- statusline refresh (each scroll tick spawned a jj subprocess).
      local jj_desc = ''
      local function refresh_jj_description()
        vim.system(
          { 'jj', 'log', '-T', 'description.first_line()', '--no-graph', '--color=never', '--ignore-working-copy', '-r', '@' },
          { text = true },
          function(out)
            local result = vim.trim(out.stdout or '')
            if out.code ~= 0 then
              jj_desc = ''
            elseif result ~= '' then
              jj_desc = result
            else
              jj_desc = '(empty)'
            end
          end
        )
      end

      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'FocusGained', 'TermLeave' }, {
        group = vim.api.nvim_create_augroup('LualineJjDescription', { clear = true }),
        callback = refresh_jj_description,
      })
      refresh_jj_description()

      local function jj_description()
        return jj_desc
      end

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
          theme = "catppuccin-macchiato",
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
          lualine_b = {
            jj_description,
            'diff',
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
