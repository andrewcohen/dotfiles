vim.keymap.set("n", "<leader>gg", function()
  require("helpers.tmux").open_or_jump_to_window("lazygit")
end, { desc = "Open or jump to Lazygit in tmux" })


return {
}
