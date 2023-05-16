return {
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
      vim.cmd [[
        hi TreesitterContextBottom gui=underline guisp=Grey
        hi TreesitterContextLineNumber guifg=#eed49f
      ]]
    end
  },

  -- LSP

  {
    'neovim/nvim-lspconfig',
    config = function()
      require('lsp').setup()
    end
  },


  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        border = "rounded"
      }
    }
  },

  -- CMP

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
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup({
        disable_filetype = { "TelescopePrompt", "vim" },
      })
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
    end
  },


  { 'tpope/vim-surround' },
  { 'sbdchd/neoformat' },

  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    opts = {}
  },

  { 'tpope/vim-fugitive' },
  { 'tpope/vim-rhubarb' },


  { 'christoomey/vim-tmux-navigator' },

  {
    "folke/trouble.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    opts = {}
  },

  {
    'ray-x/go.nvim',
    config = function()
      require('go').setup({
        tag_transform = 'camelcase',
        dap_debug_keymap = false,
      })
    end
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

  -- sizzle
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end
  },

  { 'jose-elias-alvarez/typescript.nvim' },

  {
    'TimUntersberger/neogit',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      require('neogit').setup({
        disable_commit_confirmation = true
      })
    end
  },

  {
    'github/copilot.vim',
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
    end
  },
  { 'folke/zen-mode.nvim' },
  {
    'dmmulroy/tsc.nvim',
    config = true
  },
  {
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require('notify')
    end
  },
}
