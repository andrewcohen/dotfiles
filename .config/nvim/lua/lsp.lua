local M = {}

local function has_value(tab, val)
  for _, value in ipairs(tab) do
    if value == val then
      return true
    end
  end

  return false
end

M.icons = {
  Class = " ",
  Color = " ",
  Constant = " ",
  Constructor = " ",
  Enum = "了 ",
  EnumMember = " ",
  Field = " ",
  File = " ",
  Folder = " ",
  Function = " ",
  Interface = "ﰮ ",
  Keyword = " ",
  Method = "ƒ ",
  Module = " ",
  Property = " ",
  Snippet = "﬌ ",
  Struct = " ",
  Text = " ",
  Unit = " ",
  Value = " ",
  Variable = " ",
}

-- protocol.CompletionItemKind = {
--   '', -- Text
--   '', -- Method
--   '', -- Function
--   '', -- Constructor
--   '', -- Field
--   '', -- Variable
--   '', -- Class
--   'ﰮ', -- Interface
--   '', -- Module
--   '', -- Property
--   '', -- Unit
--   '', -- Value
--   '', -- Enum
--   '', -- Keyword
--   '﬌', -- Snippet
--   '', -- Color
--   '', -- File
--   '', -- Reference
--   '', -- Folder
--   '', -- EnumMember
--   '', -- Constant
--   '', -- Struct
--   '', -- Event
--   'ﬦ', -- Operator
--   '', -- TypeParameter
-- }

function M.setup()
  local nvim_lsp = require('lspconfig')
  local protocol = require('vim.lsp.protocol')

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local common_on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Mappings.
    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '<leader>gr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', opts)
    vim.keymap.set('n', '<leader>gs', function()
      require 'telescope.builtin'.lsp_document_symbols({
        symbol_width = 50,     -- make the symbols a bit wider than the 25 by default otherwise they are always cut off
        symbol_type_width = 0, -- doesn't matter how wide the symbol type is
        symbols = { 'function', 'method' }
      })
    end)

    buf_set_keymap('n', '<leader>gS', '<cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<CR>', opts)
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    buf_set_keymap("n", "<leader>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

    buf_set_keymap('n', '<leader>gD', '', {
      noremap = true,
      callback = function()
        vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end,
    })

    buf_set_keymap('n', '<leader>gd', '', {
      noremap = true,
      callback = function()
        vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
      end,
    })

    buf_set_keymap('n', '<leader>ga', '', {
      noremap = true,
      callback = function()
        if #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }) > 0 then
          vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
          vim.lsp.buf.code_action()
        else
          print("no errors to correct")
        end
      end,
    })

    buf_set_keymap('n', '<leader>gA', '', {
      noremap = true,
      callback = function()
        if #vim.diagnostic.get(0) > 0 then
          vim.diagnostic.goto_next()
          vim.lsp.buf.code_action()
        else
          print("no diagnostics to correct")
        end
      end,
    })

    local fmt_augroup = vim.api.nvim_create_augroup("lsp_fmt", { clear = true })
    local ft = vim.bo.filetype

    if ft == "go" or ft == "gomod" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = fmt_augroup,
        desc = "lsp formatter",
        callback = function()
          require('go.format').goimport()
          require('go.format').gofmt()
        end
      })
    elseif has_value({ 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' }, ft) then
      local root_file = {
        '.eslintrc',
        '.eslintrc.js',
        '.eslintrc.cjs',
        '.eslintrc.yaml',
        '.eslintrc.yml',
        '.eslintrc.json',
        'eslint.config.js',
      }
      local has_eslint_cfg = require('lspconfig').util.root_pattern(unpack(root_file))(vim.api.nvim_buf_get_name(
        bufnr))
      if not has_eslint_cfg then
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = fmt_augroup,
          desc = "lsp formatter",
          callback = function()
            vim.api.nvim_command [[silent! Neoformat]]
          end
        })
      end
    else
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = fmt_augroup,
        desc = "lsp formatter",
        callback = function()
          vim.lsp.buf.formatting_sync()
        end
      })
    end


    if client.name == "gopls" then
      buf_set_keymap("n", "<leader>dt", "<cmd>lua require('dap-go').debug_test()<CR>", opts)
    end
  end

  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- local lsp_installer = require("nvim-lsp-installer")

  -- lsp_installer.setup {}
  require("mason").setup()

  local kinds = vim.lsp.protocol.CompletionItemKind
  for i, kind in ipairs(kinds) do
    kinds[i] = M.icons[kind] or kind
  end

  local border = {
    { "╭", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╮", "FloatBorder" },
    { "│", "FloatBorder" },
    { "╯", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╰", "FloatBorder" },
    { "│", "FloatBorder" },
  }

  -- LSP settings (for overriding per client)
  local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
  }

  local servers = {
    'gopls',
    'golangci_lint_ls',
    'lua_ls',
    'gdscript',
    'jsonls',
    'tailwindcss',
    'emmet_ls'
  }

  for _, lsp in pairs(servers) do
    require('lspconfig')[lsp].setup {
      on_attach = common_on_attach,
      capabilities = capabilities,
      handlers = handlers
    }
  end

  -- eslint lsp wont attach if the eslint root file is absent
  require('lspconfig').eslint.setup({
    on_attach = function(client, bufnr)
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        command = "EslintFixAll",
      })
    end,
  })

  local rust_tools = require("rust-tools")
  local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.7.0/'
  local codelldb_path = extension_path .. 'adapter/codelldb'
  local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'

  rust_tools.setup {
    server = {
      on_attach = common_on_attach,
      capabilities = capabilities,
      handlers = handlers,
      settings = {
        ["rust-analyzer"] = {
          -- https://github.com/simrat39/rust-tools.nvim/issues/300
          inlayHints = { locationLinks = false },
        },
      }
    },
    dap = {
      adapter = require('rust-tools.dap').get_codelldb_adapter(
        codelldb_path, liblldb_path)
    }
  }

  local function filter(arr, fn)
    if type(arr) ~= "table" then
      return arr
    end

    local filtered = {}
    for k, v in pairs(arr) do
      if fn(v, k, arr) then
        table.insert(filtered, v)
      end
    end

    return filtered
  end

  local function tprint(tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
      formatting = string.rep("  ", indent) .. k .. ": "
      if type(v) == "table" then
        print(formatting)
        tprint(v, indent + 1)
      elseif type(v) == 'boolean' then
        print(formatting .. tostring(v))
      else
        print(formatting .. v)
      end
    end
  end

  local function filterReactDTS(value)
    if value == nil or value.targetUri == nil then
      tprint(value)
      return true
    end

    -- return string.match(value.targetUri, 'react/index.d.ts') == nil
    return string.match(value.targetUri, '%.d.ts') == nil
  end

  local typescript_handlers = {
    ['textDocument/definition'] = function(err, result, method, ...)
      if vim.tbl_islist(result) and #result > 1 then
        local filtered_result = filter(result, filterReactDTS)
        return vim.lsp.handlers['textDocument/definition'](err, filtered_result, method, ...)
      end

      vim.lsp.handlers['textDocument/definition'](err, result, method, ...)
    end
  }

  local merge = function(a, b)
    local c = {}
    for k, v in pairs(a) do c[k] = v end
    for k, v in pairs(b) do c[k] = v end
    return c
  end

  require("typescript").setup({
    server = {
      handlers = merge(handlers, typescript_handlers),
      capabilities = capabilities,
      init_options = {
        npmLocation = "/opt/homebrew/bin/npm"
      },
      on_attach = function(client, bufnr)
        common_on_attach(client, bufnr)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", "",
          {
            silent = true,
            callback = function()
              local ts = require('typescript').actions
              ts.removeUnused({ sync = true })
              ts.organizeImports({ sync = true })
            end
          })
      end,
    }
  })
end -- func M.setup()

return M
