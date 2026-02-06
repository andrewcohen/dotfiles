vim.keymap.set("n", "<leader>O", function()
  require("helpers.tmux").open_or_jump_to_window("opencode")
end, { desc = "Open or jump to Opencode in tmux" })

return {
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   opts = {
  --     suggestion = { enabled = false },
  --     panel = { enabled = false },
  --     filetypes = {
  --       markdown = true,
  --       help = true,
  --     },
  --   },
  -- },
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
  {
    "ggml-org/llama.vim",
    enabled = true,
    -- load on demand-ish; you can change to VeryLazy if you want
    -- event = "InsertEnter",
    init = function()
      -- llama.vim reads g:llama_config (vim.g.llama_config in Lua) :contentReference[oaicite:1]{index=1}
      vim.g.llama_config = {
        -- Where your llama-server listens (this is the documented default) :contentReference[oaicite:2]{index=2}
        -- endpoint = "http://127.0.0.1:8012/infill",

        -- IMPORTANT: don’t auto-trigger while moving/typing; keep blink/LSP as primary :contentReference[oaicite:3]{index=3}
        auto_fim = true,


        -- Keymaps: avoid <Tab>, avoid <C-h/j/k/l>, avoid Alt/Option.
        -- These options are in llama.vim’s defaults table. :contentReference[oaicite:4]{index=4}
        -- keymap_fim_trigger = "<C-x><C-f>",     -- request infill manually
        keymap_fim_accept_full = "<C-a>", -- accept full suggestion
        keymap_fim_accept_line = "<C-e>", -- accept one line
        keymap_fim_accept_word = "<C-d>", -- accept one word

        show_info = 0,
      }
    end,
    config = function()
      -- Detect floating windows on BufEnter
      vim.api.nvim_create_autocmd("BufEnter", {
        -- group = augroup,
        pattern = "*",
        callback = function()
          -- Check if the buffer is in a floating window
          local buftype = vim.bo.buftype
          local is_floating = vim.api.nvim_win_get_config(0).relative ~= ""
          if is_floating or buftype == "prompt" or buftype == "nofile" or buftype == "popup" then
            -- Disable completion (affects plugins like llama.vim if they use completion)
            vim.opt_local.completeopt = { "menu", "menuone", "noselect" }
            vim.opt_local.complete = "" -- Disable completion sources
            vim.cmd("LlamaDisable")

            -- Hypothetical: Disable specific plugins using buffer-local variables
            -- Optionally, remove plugin-specific keymaps (e.g., if plugin uses <Tab>)
          else
            -- Restore settings for non-floating windows
            vim.opt_local.completeopt = { "menu", "menuone", "noselect", "noinsert" }
            vim.opt_local.complete = ".,w,b,u,t,i"
            vim.cmd("LlamaEnable")
          end
        end,
      })
    end,

  },
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

  { "echasnovski/mini.pick", config = function() require("mini.pick").setup() end },
}
