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
          "lua",
          "go",
          "html",
          "javascript",
          "json",
          "tsx",
          "typescript",
          "yaml",
        },
        highlight = {
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

  use {
    'glepnir/lspsaga.nvim',
    config = function()
      require'lspsaga'.init_lsp_saga {
        border_style = "round",
        error_sign = '',
        warn_sign = '',
        hint_sign = '',
        infor_sign = '',
      }
    end
  }

  -- Theming
  use 'monsonjeremy/onedark.nvim'
  use 'morhetz/gruvbox'
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

  use {
    'hrsh7th/nvim-compe',
    config = function()
      require('compe').setup {
        enabled = true;
        autocomplete = true;
        debug = false;
        min_length = 1;
        preselect = 'enable';
        throttle_time = 80;
        source_timeout = 200;
        resolve_timeout = 800;
        incomplete_delay = 400;
        max_abbr_width = 100;
        max_kind_width = 100;
        max_menu_width = 100;
        documentation = {
          -- border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
          border_style = "round",
          winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
          max_width = 120,
          min_width = 60,
          max_height = math.floor(vim.o.lines * 0.3),
          min_height = 1,
        };

        source = {
          path = true;
          buffer = true;
          calc = true;
          nvim_lsp = true;
          nvim_lua = true;
          vsnip = true;
          ultisnips = true;
          luasnip = true;
        };
      }
    end
  }

  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({
        disable_filetype = { "TelescopePrompt" , "vim" },
        enable_check_bracket_line = true,
      })
      require("nvim-autopairs.completion.compe").setup({
        map_cr = true, --  map <CR> on insert mode
        map_complete = true -- it will auto insert `(` after select function or method item
      })
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
            n = {
              ["q"] = actions.close
            }
          }
        }
      }
    end
  }

  --[[ use {
    'kyazdani42/nvim-tree.lua',
    requires = {{'kyazdani42/nvim-web-devicons'}}
  } ]]

  use 'b3nj5m1n/kommentary'
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
    'ray-x/go.nvim',
    config = function()
      require('go').setup()
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
