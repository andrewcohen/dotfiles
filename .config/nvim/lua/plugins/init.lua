return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        auto_install = true,
        -- sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
    -- build = ":TSUpdate",
    -- dependencies = {
    --   "windwp/nvim-ts-autotag",
    -- },
    -- main = "nvim-treesitter.configs",
    -- opts = {
    --   auto_install = true,
    --   highlight = {
    --     enable = true
    --   },
    --   indent = {
    --     enable = true
    --   }
    -- }
  },

  {
    "windwp/nvim-ts-autotag",
    config = function()
      require('nvim-ts-autotag').setup({
        opts = {
          -- Defaults
          enable_close = true,          -- Auto close tags
          enable_rename = true,         -- Auto rename pairs of tags
          enable_close_on_slash = false -- Auto close on trailing </
        },
        -- Also override individual filetype configs, these take priority.
        -- Empty by default, useful if one of the "opts" global settings
        -- doesn't work well in a specific filetype
        per_filetype = {
          ["html"] = {
            enable_close = false
          }
        }
      })
    end
  },

  { "nvim-treesitter/playground" },
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = function()
      vim.cmd [[
        hi TreesitterContextBottom gui=underline guisp=Grey
        hi TreesitterContextLineNumber guifg=#eed49f
      ]]
      return {
        patterns = {
          default = {
            "class",
            "function",
            "method",
            "jsx_opening_element",
            "jsx_self_closing_element "
          },
        },
        multiline_threshold = 1,
      }
    end
  },

  -- LSP

  {
    "neovim/nvim-lspconfig",
    dependencies = { 'saghen/blink.cmp' },
    config = function()
      require("lsp").setup()
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
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      menu = {
        -- width = vim.api.nvim_win_get_width(0) - 4,
        width = 120
      }
    }
  },

  -- completion & snippets
  { "rafamadriz/friendly-snippets" },

  { "tpope/vim-commentary" },
  { "JoosepAlviste/nvim-ts-context-commentstring" },


  { "tpope/vim-surround" },
  { "sbdchd/neoformat" },

  {
    "lewis6991/gitsigns.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    opts = {}
  },

  {
    "tpope/vim-fugitive",
    dependencies = "tpope/vim-rhubarb"
  },
  { "tpope/vim-rhubarb" },


  { "christoomey/vim-tmux-navigator" },

  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {}
  },

  {
    "ray-x/go.nvim",
    opts = {
      tag_transform = "camelcase",
      dap_debug_keymap = false,
    }
  },

  {
    "simrat39/rust-tools.nvim",
    -- https://github.com/simrat39/rust-tools.nvim/issues/157
    -- 'Freyskeyd/rust-tools.nvim',
    -- branch = 'dap_fix',
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap"
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
    "folke/zen-mode.nvim",
    opts = {
      window = {
        options = {
          number = false,
          relativenumber = false,
          wrap = true,
          linebreak = true,
          cursorline = false,
          signcolumn = "no"
        }
      }
    }
  },
  {
    "dmmulroy/tsc.nvim",
    config = function()
      require("tsc").setup({
        -- flags = {
        --   watch = true,
        -- }
      })
    end
  },
  { "ziglang/zig.vim" },
  {
    "stevearc/oil.nvim",
    opts = {
      view_options = {
        show_hidden = true
      }
    },
    keys = {
      { "<leader>E", "<cmd>Oil --float<cr>" }
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

  {
    'ggandor/leap.nvim',
    config = function()
      require('leap').create_default_mappings()
    end
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },
}
