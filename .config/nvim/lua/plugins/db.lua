require("helpers.db_table_export").setup()

return {
  {
    'tpope/vim-dadbod',
    lazy = true,
  },
  {
    'kristijanhusak/vim-dadbod-completion',
    ft = { 'sql', 'mysql', 'plsql' },
    dependencies = { 'tpope/vim-dadbod' },
    lazy = true,
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_use_postgres_views = 0
    end,
    keys = {
      { "<leader>da", "<cmd>DBUIToggle<cr>", desc = "open dbui (dadbod)" }
    }
  },
}
