vim.keymap.set("n", "<leader>O", function()
  require("helpers.tmux").open_or_jump_to_window("opencode")
end, { desc = "Open or jump to Opencode in tmux" })

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    tag = 'v17.33.0',
    pin = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "j-hui/fidget.nvim"
    },
    opts = {
      adapters = {
        http = {
          copilot = function()
            return require('codecompanion.adapters').extend('copilot', {
              schema = {
                model = {
                  -- default = 'gpt-4.1'
                  default = "claude-sonnet-4"
                }
              }
            })
          end
        }
      },
      display = {
        action_palette = {
          provider = "mini_pick"
        },
        -- diff = {
        --   provider = "mini_diff"
        -- }
      },
      strategies = {
        chat = {
          variables = {
            ["buffer"] = {
              opts = {
                default_params = 'watch',
              },
            },
          },
        }
      }
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)
      -- Command abbreviation for CodeCompanion
      vim.cmd([[cab cc CodeCompanion]])
      require("plugins.codecompanion.fidget-spinner"):init()
    end,
    keys = {
      -- { "<leader>cA", "<cmd>CodeCompanionActions<cr>",     mode = { "n", "v" }, desc = "CodeCompanion Actions" },
      { "<leader>C", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle CodeCompanion Chat" },
      -- { "ga",         "<cmd>CodeCompanionChat Add<cr>",    mode = "v",          desc = "Add to CodeCompanion Chat" },
    },
  },
  -- {
  -- "azorng/goose.nvim",
  -- config = function()
  --   require("goose").setup({
  --     preferred_picker = "mini_pick"
  --   })
  -- end,
  -- dependencies = {
  --   "nvim-lua/plenary.nvim",
  --   "echasnovski/mini.pick",
  --   {
  --     "MeanderingProgrammer/render-markdown.nvim",
  --     opts = {
  --       anti_conceal = { enabled = false },
  --     },
  --   }
  -- },
  -- },
  {
    "echasnovski/mini.diff",
    config = function()
      local diff = require("mini.diff")
      diff.setup({
        -- Disabled by default
        source = diff.gen_source.none(),
      })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" }
  },
  -- {
  --   "yetone/avante.nvim",
  --   event = "VeryLazy",
  --   version = false, -- Never set this value to "*"! Never!
  --   opts = {
  --     mode = "agentic",
  --     provider = "ollama",
  --     cursor_applying_provider = 'ollama',
  --     behaviour = {
  --       -- enable_cursor_planning_mode = true, -- enable cursor planning mode!
  --     },
  --     providers = {
  --       copilot = {
  --         model = "gpt-4.1",
  --       },
  --       ollama = {
  --         model = "llama3.1:8b"
  --       },
  --     },
  --     selector = { provider = "mini_pick" }
  --   },
  --   -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  --   build = "make",
  --   -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "stevearc/dressing.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     --- The below dependencies are optional,
  --     "echasnovski/mini.pick", -- for file_selector provider mini.pick
  --     -- "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
  --     -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
  --     -- "ibhagwan/fzf-lua", -- for file_selector provider fzf
  --     -- "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  --     -- "zbirenbaum/copilot.lua", -- for providers='copilot'
  --     -- {
  --     --   -- support for image pasting
  --     --   "HakonHarnes/img-clip.nvim",
  --     --   event = "VeryLazy",
  --     --   opts = {
  --     --     -- recommended settings
  --     --     default = {
  --     --       embed_image_as_base64 = false,
  --     --       prompt_for_file_name = false,
  --     --       drag_and_drop = {
  --     --         insert_mode = true,
  --     --       },
  --     --       -- required for Windows users
  --     --       use_absolute_path = true,
  --     --     },
  --     --   },
  --     -- },
  --     {
  --       -- Make sure to set this up properly if you have lazy=true
  --       'MeanderingProgrammer/render-markdown.nvim',
  --       opts = {
  --         file_types = { "markdown", "Avante" },
  --       },
  --       ft = { "markdown", "Avante" },
  --     },
  --   },
  -- },

  { "echasnovski/mini.pick", config = function() require("mini.pick").setup() end },
  -- {
  --   "ravitemer/mcphub.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  --   build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
  --   config = function()
  --     require("mcphub").setup()
  --   end
  -- }
}
