return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    branch = "main",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-context",
        config = true,
        opts = {
          enable = true,
          max_lines = 3,
          multiline_threshold = 1,
          min_window_height = 20,
        },

        keys = {
          { "<leader>uC", ":TSContextToggle<CR>", desc = "Toggle TSContext" },
          {
            "[c",
            ":lua require('treesitter-context').go_to_context()<cr>",
            silent = true,
            desc = "Go to context",
          },
        },
      },
    },
    opts = {
      ensure_installed = {
        "javascript",
        "typescript",
        "tsx",
        "lua",
        "jsdoc",
        "json",
        "json5",
        "jsonc",
        "prisma",
        "sql",
        "regex",
        "html",
        "css",
        "scss",
        "jsdoc",
        "astro",
        "go",
        "gomod",
        "bash",
        "markdown",
        "http",
        "markdown_inline",
        "query",
        "vim",
        "vimdoc",
        "gitignore",
        "gitcommit",
        "git_config",
        "diff",
        "http",
        "git_rebase",
        "toml",
        "yaml",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup()
      require("nvim-treesitter").install(opts.ensure_installed)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "astro",
          "css",
          "diff",
          "gitcommit",
          "gitconfig",
          "gitignore",
          "gitrebase",
          "go",
          "gomod",
          "html",
          "http",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "regex",
          "scss",
          "sh",
          "sql",
          "toml",
          "typescript",
          "typescriptreact",
          "vim",
          "vimdoc",
          "yaml",
        },
        callback = function()
          local ok = pcall(vim.treesitter.start)
          if not ok then
            print("Treesitter not enabling")
            return
          end
        end,
      })
    end,
  },
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   build = ":TSUpdate",
  --   branch = "main",
  --   lazy = "false",
  --   init = function()
  --     require("nvim-treesitter").update()

  --     vim.api.nvim_create_autocmd('FileType', {
  --       pattern = { '*' },
  --       callback = function(e)
  --         print("start TS")
  --         vim.treesitter.start()
  --       end,
  --     })
  --   end
  --   -- config = function()
  --   --   local configs = require("nvim-treesitter.configs")

  --   --   configs.setup({
  --   --     auto_install = true,
  --   --     -- sync_install = false,
  --   --     highlight = { enable = true },
  --   --     indent = { enable = true },
  --   --   })
  --   -- end

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

  -- { "nvim-treesitter/playground" },
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
  -- { "sbdchd/neoformat" },

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

  -- {
  --   "ray-x/go.nvim",
  --   opts = {
  --     tag_transform = "camelcase",
  --     dap_debug_keymap = false,
  --     diagnostic = false
  --   }
  -- },

  {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
    lazy = false,   -- This plugin is already lazy
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
      vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
      vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
    end
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },

  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true }
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
  },
  {
    "hat0uma/csvview.nvim",
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      parser = { comments = { "#", "//" } },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  }
}
