vim.keymap.set("n", "<leader>gg", function()
  local windows = vim.fn.systemlist("tmux list-windows")
  local found = false
  for _, win in ipairs(windows) do
    if win:match("lazygit") then
      found = true
      break
    end
  end

  if found then
    vim.fn.jobstart({ "tmux", "select-window", "-t", "lazygit" }, { detach = true })
  else
    vim.fn.jobstart({
      "tmux", "new-window",
      "-n", "lazygit",
      "-c", vim.fn.getcwd(),
      "lazygit"
    }, { detach = true })
  end
end, { desc = "Open or jump to Lazygit in tmux" })


return {
}
