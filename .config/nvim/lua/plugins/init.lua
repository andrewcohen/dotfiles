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
    config = function()
      require('mason').setup({
        ui = {
          border = "rounded"
        }
      })
    end
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
    -- commit = '208c80e',
    config = function()
      -- enhanced dap theming for catppuccin
      require("dap")
      local sign = vim.fn.sign_define
      sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
    end
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
  }
}
