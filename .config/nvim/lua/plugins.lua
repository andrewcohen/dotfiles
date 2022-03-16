local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
-- bootstrap packer install
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
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
      require'nvim-treesitter.configs'.setup {
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

  use {
    'neovim/nvim-lspconfig',

    config = function ()
      require('lsp').setup()
    end
  }

  use { 'williamboman/nvim-lsp-installer' }

  -- Theming
  use {
    'monsonjeremy/onedark.nvim',
    config = function()
      require('onedark').setup()
    end
  }

  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons'},
    config = function()
      require('lualine').setup { theme = "onedark" }
    end
  }

  -- use {
  --   'romgrk/barbar.nvim',
  --   requires = {'kyazdani42/nvim-web-devicons'},
  -- }
  --

  use {
    'ThePrimeagen/harpoon',
    requires = {'nvim-lua/plenary.nvim'},
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
        disable_filetype = { "TelescopePrompt" , "vim" },
      })
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
    end
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
    config = function ()
      local actions = require('telescope.actions')
      require('telescope').setup {
        defaults = {
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

      require("telescope").load_extension('harpoon')
    end
  }

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
      require("trouble").setup { }
    end
  }

  use {
    'ray-x/go.nvim',
    config = function()
      require('go').setup({
        tag_transform = 'camelcase'
      })
    end
  }


  use {
    'simrat39/rust-tools.nvim',
    requires = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
      'mfussenegger/nvim-dap'
    },
    config = function()
      require('rust-tools').setup({})
    end
  }

  -- sizzle
  use {'stevearc/dressing.nvim'}

  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  use 'jose-elias-alvarez/nvim-lsp-ts-utils'
  use 'ggandor/lightspeed.nvim'

end)
