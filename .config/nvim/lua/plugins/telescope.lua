local project_files = function()
  local ok = pcall(require('telescope.builtin').git_files, { show_untracked = true })
  if not ok then require('telescope.builtin').find_files({}) end
end

local dir_files = function()
  require('telescope.builtin').find_files({ cwd = vim.fn.expand('%:p:h') })
end

local additional_args = { '--hidden', '-g', '!.git', '-g', '!.jj' }

return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>ff', project_files },
      { '<leader>fg', function() require('telescope.builtin').live_grep({ additional_args = additional_args }) end },
      { '<leader>fw', '<cmd>Telescope grep_string<cr>' },
      {
        '<leader>fw',
        function()
          function vim.getVisualSelection()
            vim.cmd('noau normal! "vy"')
            local text = vim.fn.getreg('v')
            vim.fn.setreg('v', {})

            text = string.gsub(text, "\n", "")
            if #text > 0 then
              return text
            else
              return ''
            end
          end

          local text = vim.getVisualSelection()
          require("telescope.builtin").live_grep({ default_text = text, additional_args })
        end,
        mode = "v"
      },
      { '<leader>fb', '<cmd>Telescope buffers<cr>' },
      { '<leader>fh', '<cmd>Telescope help_tags<cr>' },
      { '<leader>fo', '<cmd>Telescope oldfiles<cr>' },
      { '<leader>fs', '<cmd>Telescope git_status<cr>' },
      { '<leader>fc', '<cmd>Telescope git_commits<cr>' },
      -- { '<leader>E',  '<cmd>Telescope file_browser path=%:p:h <cr>' },
      { '<leader>fd', dir_files }
    },
    config = function()
      local actions = require('telescope.actions')
      require('telescope').setup {
        defaults = {
          border = true,
          layout_strategy = 'flex',
          sorting_strategy = 'ascending',
          layout_config = {
            prompt_position = 'top',
            --   width = 0.9,
            --   height = 0.8,
            --   horizontal = {
            --     width = { padding = 0.15 },
            --   },
            --   vertical = {
            --     preview_height = 0.75,
            --   },
          },
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
          },
          -- live_grep = {
          --   additional_args = function(opts)
          --     return { "--hidden" }
          --   end
          -- },
        }
      }

      require('telescope').load_extension('harpoon')
      require('telescope').load_extension('dap')
      require('telescope').load_extension('file_browser')
    end
  },
  { "nvim-telescope/telescope-file-browser.nvim" },
}
