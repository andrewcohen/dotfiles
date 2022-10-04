local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
-- bootstrap packer install
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
  vim.api.nvim_command 'packadd packer.nvim'
end

vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- LSP
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {
      'windwp/nvim-ts-autotag',
    },
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = {
          "bash",
          "css",
          "go",
          "html",
          "javascript",
          "json",
          "lua",
          "rust",
          "tsx",
          "typescript",
          "yaml",
          "zig"
        },
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
  }

  use 'nvim-treesitter/playground'
  use {
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

      vim.cmd [[
        hi TreesitterContext guibg=#383d47
        hi TreesitterContextLineNumber guibg=#383d47
      ]]
    end
  }


  use {
    'neovim/nvim-lspconfig',

    config = function()
      require('lsp').setup()
    end
  }

  use { 'williamboman/nvim-lsp-installer' }

  -- Theming

  use {
    'ful1e5/onedark.nvim',
    config = function()
      require('onedark').setup({
        hide_inactive_statusline = false,
        highlight_linenumber = true
      })
    end
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    after = 'onedark.nvim',
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
          theme = "onedark",
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
  }


  use {
    'ThePrimeagen/harpoon',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require("harpoon").setup({
        menu = {
          -- width = vim.api.nvim_win_get_width(0) - 4,
          width = 120
        }
      })
    end
  }

  -- completion & snippets
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
    }
  }

  use 'rafamadriz/friendly-snippets'

  use 'tpope/vim-commentary'
  use 'JoosepAlviste/nvim-ts-context-commentstring'

  use {
    'windwp/nvim-autopairs',
    requires = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup({
        disable_filetype = { "TelescopePrompt", "vim" },
      })
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
    end
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } },
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
  }
  use { "nvim-telescope/telescope-file-browser.nvim" }

  use 'tpope/vim-surround'
  use 'sbdchd/neoformat'

  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup()
    end
  }

  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'


  use { 'christoomey/vim-tmux-navigator' }

  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {}
    end
  }

  use {
    'ray-x/go.nvim',
    config = function()
      require('go').setup({
        tag_transform = 'camelcase',
        dap_depbug_keymap = false,
      })
    end
  }

  use {
    'mfussenegger/nvim-dap',
    commit = '208c80e'
  }

  use {
    "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap" },
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
  }

  -- use 'nvim-telescope/telescope-dap.nvim'
  use {
    'hendrikbursian/telescope-dap.nvim',
    commit = '04447ba487d0bbe2eb52f704f1366ea55a65bf75'
  }

  use {
    'simrat39/rust-tools.nvim',
    -- https://github.com/simrat39/rust-tools.nvim/issues/157
    -- 'Freyskeyd/rust-tools.nvim',
    -- branch = 'dap_fix',
    requires = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
      'mfussenegger/nvim-dap'
    },
    config = function()
      -- require('rust-tools').setup({})
    end
  }

  use {
    'leoluz/nvim-dap-go',
    config = function()
      require('dap-go').setup()
    end
  }

  -- sizzle
  use { 'stevearc/dressing.nvim' }

  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end
  }

  use 'jose-elias-alvarez/typescript.nvim'

  use 'ziglang/zig.vim'

  use 'habamax/vim-godot'

  use {
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup()
    end
  }

  use {
    'TimUntersberger/neogit',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('neogit').setup({
        disable_commit_confirmation = true
      })
    end
  }
end)
