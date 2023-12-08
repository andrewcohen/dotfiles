return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'windwp/nvim-ts-autotag',
    },
    main = 'nvim-treesitter.configs',
    opts = {
      auto_install = true,
      highlight = {
        enable = true
      },
      autotag = {
        enable = true,
        enable_close_on_slash = false,
      },
      indent = {
        enable = true
      }
    }
  },

  { 'nvim-treesitter/playground' },
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = function()
      vim.cmd [[
        hi TreesitterContextBottom gui=underline guisp=Grey
        hi TreesitterContextLineNumber guifg=#eed49f
      ]]
      return {
        patterns = {
          default = {
            'class',
            'function',
            'method',
            'jsx_opening_element',
            'jsx_self_closing_element '
          },
        }
      }
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
    opts = {
      menu = {
        -- width = vim.api.nvim_win_get_width(0) - 4,
        width = 120
      }
    }
  },

  -- completion & snippets
  { 'rafamadriz/friendly-snippets' },

  { 'tpope/vim-commentary' },
  { 'JoosepAlviste/nvim-ts-context-commentstring' },


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
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {}
  },

  {
    'ray-x/go.nvim',
    opts = {
      tag_transform = 'camelcase',
      dap_debug_keymap = false,
    }
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
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {}
  },

  {
    'NeogitOrg/neogit',
    dependencies = 'nvim-lua/plenary.nvim',
    opts = {
      disable_commit_confirmation = true
    }
  },

  {
    "zbirenbaum/copilot.lua",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end
  },


  --   {
  --     'github/copilot.vim',
  --     config = function()
  --       vim.g.copilot_no_tab_map = true
  --       vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
  --       vim.g.copilot_filetypes = { ['dap-repl'] = false, ['TelescopePrompt'] = false, ['NeogitCommitMessage'] = false }
  --     end,
  --   },

  { 'folke/zen-mode.nvim' },
  {
    'dmmulroy/tsc.nvim',
    config = function()
      require('tsc').setup({
        -- flags = {
        --   watch = true,
        -- }
      })
    end
  },
  { 'ziglang/zig.vim' },
  {
    'stevearc/oil.nvim',
    opts = {
      view_options = {
        show_hidden = true
      }
    },
    keys = {
      { '<leader>E', '<cmd>Oil --float<cr>' }
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
