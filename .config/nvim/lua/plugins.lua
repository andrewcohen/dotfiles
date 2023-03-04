local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none", "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local plugins = {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato",
        transparent_background = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          harpoon = true,
          lsp_trouble = true,
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
      })
      vim.cmd.colorscheme "catppuccin"
    end
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
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
          -- theme = "tokyonight",
          theme = "catppuccin",
          component_separators = '|',
          section_separators = { left = '', right = '' },
          extensions = { dapui }
          -- disabled_filetypes = {
          --   'dapui_scopes',
          --   'dapui_stacks',
          --   'dapui_breakpoints',
          --   'dapui_watches',
          -- }
        }
        -- ['dapui_scopes'] = 'DAP Scopes',
        -- ['dapui_stacks'] = 'DAP Stacks',
        -- ['dapui_breakpoints'] = 'DAP Breakpoints',
        -- ['dapui_watches'] = 'DAP Watches',
      }
    end
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'windwp/nvim-ts-autotag',
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        auto_install = true,
        highlight = {
          enable = true
        },
        context_commentstring = {
          enable = true
        },
        autotag = {
          enable = true
        },
      }
    end
  },

  { 'nvim-treesitter/playground' },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup({
        patterns = {
          default = {
            'class',
            'function',
            'method',
            'jsx_opening_element',
            'jsx_self_closing_element '
          },
        }
      })
    end
  },

  -- LSP

  {
    'neovim/nvim-lspconfig',
    config = function()
      require('lsp').setup()
    end
  },


  { "williamboman/mason.nvim" },

  -- CMP

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
    }
  },

  {
    'ThePrimeagen/harpoon',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require("harpoon").setup({
        menu = {
          -- width = vim.api.nvim_win_get_width(0) - 4,
          width = 120
        }
      })
    end
  },

  -- completion & snippets
  { 'rafamadriz/friendly-snippets' },

  { 'tpope/vim-commentary' },
  { 'JoosepAlviste/nvim-ts-context-commentstring' },

  {
    'windwp/nvim-autopairs',
    depeendencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup({
        disable_filetype = { "TelescopePrompt", "vim" },
      })
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
    end
  },

  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
    config = function()
      local actions = require('telescope.actions')
      require('telescope').setup {
        defaults = {
          -- layout_strategy = 'flex',
          sorting_strategy = 'ascending',
          layout_config = {
            prompt_position = 'top',
            width = 0.9,
            height = 0.8,
            horizontal = {
              width = { padding = 0.15 },
            },
            vertical = {
              preview_height = 0.75,
            },
          },
          mappings = {
            i = {
                  ["<C-j>"] = actions.move_selection_next,
                  ["<C-k>"] = actions.move_selection_previous,
            },
            n = {
                  ["q"] = actions.close
            }
          }
        },
        pickers = {
          buffers = {
            mappings = {
              i = {
                    ["<c-d>"] = actions.delete_buffer,
              },
              n = {
                    ["<c-d>"] = actions.delete_buffer,
              },
            }
          }
        }
      }

      require('telescope').load_extension('harpoon')
      require('telescope').load_extension('dap')
      require('telescope').load_extension('file_browser')
    end
  },
  { "nvim-telescope/telescope-file-browser.nvim" },

  { 'tpope/vim-surround' },
  { 'sbdchd/neoformat' },

  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup()
    end
  },

  { 'tpope/vim-fugitive' },
  { 'tpope/vim-rhubarb' },


  { 'christoomey/vim-tmux-navigator' },

  {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {}
    end
  },

  {
    'ray-x/go.nvim',
    config = function()
      require('go').setup({
        tag_transform = 'camelcase',
        dap_depbug_keymap = false,
      })
    end
  },

  {
    'mfussenegger/nvim-dap',
    commit = '208c80e'
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        -- require 'mappings'.set_normal_mappings()
        dapui.setup()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        -- require 'mappings'.unset_normal_mappings()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        -- require 'mappings'.unset_normal_mappings()
        dapui.close()
      end
    end
  },

  -- use 'nvim-telescope/telescope-dap.nvim'
  {
    'hendrikbursian/telescope-dap.nvim',
    commit = '04447ba487d0bbe2eb52f704f1366ea55a65bf75'
  },

  {
    'simrat39/rust-tools.nvim',
    -- https://github.com/simrat39/rust-tools.nvim/issues/157
    -- 'Freyskeyd/rust-tools.nvim',
    -- branch = 'dap_fix',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
      'mfussenegger/nvim-dap'
    }
  },

  {
    'leoluz/nvim-dap-go',
    config = function()
      require('dap-go').setup()
    end
  },

  -- sizzle
  { 'stevearc/dressing.nvim' },

  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end
  },

  { 'jose-elias-alvarez/typescript.nvim' },

  {
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup()
    end
  },

  {
    'TimUntersberger/neogit',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      require('neogit').setup({
        disable_commit_confirmation = true
      })
    end
  }
}
require("lazy").setup(plugins, {
  ui = {
    border = "rounded"
  }
})
