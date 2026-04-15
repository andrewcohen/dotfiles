return {
  on_attach = function(_, bufnr)
    local function run_tsgo_command(command, arguments)
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        if client.name == "tsgo" and client:supports_method("workspace/executeCommand") then
          local resp = client:request_sync("workspace/executeCommand", {
            command = command,
            arguments = arguments,
          }, 3000, bufnr)

          if resp and not resp.err then
            return true
          end
        end
      end

      return false
    end

    vim.keymap.set("n", "gs", function()
      local ok = run_tsgo_command("_typescript.organizeImports", { vim.uri_from_bufnr(bufnr) })
        or run_tsgo_command("_typescript.organizeImports", { vim.api.nvim_buf_get_name(bufnr) })

      if not ok then
        vim.lsp.buf.code_action()
      end
    end, { buffer = bufnr, silent = true, desc = "Organize imports / code actions" })
  end,
}
