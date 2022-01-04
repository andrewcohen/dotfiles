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
        }
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
    config = function()
      require('lualine').setup { theme = "onedark" }
    end
  }

  use {
    'akinsho/nvim-bufferline.lua',
    requires = 'kyazdani42/nvim-web-devicons'
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

  -- use {
  --   'windwp/nvim-autopairs',
  --   config = function()
  --     require('nvim-autopairs').setup({
  --       disable_filetype = { "TelescopePrompt" , "vim" },
  --       enable_check_bracket_line = true,
  --     })
  --     require("nvim-autopairs.completion.compe").setup({
  --       map_cr = true, --  map <CR> on insert mode
  --       map_complete = true -- it will auto insert `(` after select function or method item
  --     })
  --   end
  -- }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
    config = function ()
      local actions = require('telescope.actions')
      require('telescope').setup {
        defaults = {
          mappings = {
            n = {
              ["q"] = actions.close
            }
          }
        }
      }
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

  use {'stevearc/dressing.nvim'}

end)
