local M = {}

local lspconfig = require('lspconfig')

local function has_value(tab, val)
  for _, value in ipairs(tab) do
    if value == val then
      return true
    end
  end

  return false
end

function M.setup()
  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local common_on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function nmap(lhs, rhs) vim.api.nvim_buf_set_keymap(bufnr, 'n', lhs, rhs, { noremap = true, silent = true }) end
    local opts = { noremap = true, silent = true }

    -- Mappings.

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
    buf_set_keymap('n', 'gF', '<c-w>v<cmd>lua vim.lsp.buf.definition()<CR>', opts)

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
      -- local root_file = {
      --   '.eslintrc',
      --   '.eslintrc.js',
      --   '.eslintrc.cjs',
      --   '.eslintrc.yaml',
      --   '.eslintrc.yml',
      --   '.eslintrc.json',
      --   'eslint.config.js',
      -- }
      -- local has_eslint_cfg = require('lspconfig').util.root_pattern(unpack(root_file))(vim.api.nvim_buf_get_name(
      --   bufnr))
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = fmt_augroup,
        desc = "lsp formatter",
        callback = function()
          vim.api.nvim_command [[silent! Neoformat]]
        end
      })
    else
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = fmt_augroup,
        desc = "lsp formatter",
        callback = function()
          vim.lsp.buf.format()
        end
      })
    end

    if ft == "ocaml" then
      local augroup_codelens = vim.api.nvim_create_augroup("custom-lsp-codelens", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "CursorHold" }, {
        group = augroup_codelens,
        callback = require('lsp.codelens').refresh_virtlines,
        buffer = 0
      })

      vim.keymap.set(
        "n",
        "<space>tT",
        require("lsp.codelens").toggle_virtlines,
        { silent = true, desc = "[T]oggle [T]ypes", buffer = 0 }
      )
    end


    if client.name == "gopls" then
      buf_set_keymap("n", "<leader>dt", "<cmd>lua require('dap-go').debug_test()<CR>", opts)
    end

    if client.server_capabilities.inlayHintProvider and client.name ~= "zls" then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
  end

  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  require("mason").setup()

  local kinds = vim.lsp.protocol.CompletionItemKind
  local icons = require('config.icons')
  for i, kind in ipairs(kinds) do
    kinds[i] = icons[kind] or kind
  end

  vim.diagnostic.config {
    float = { border = 'rounded' },
  }

  -- LSP settings (for overriding per client)
  local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
    ["textDocument/definition"] = function(_, result)
      if not result or vim.tbl_isempty(result) then
        print "[LSP] Could not find definition"
        return
      end

      if vim.islist(result) then
        vim.lsp.util.jump_to_location(result[1], "utf-8")
      else
        vim.lsp.util.jump_to_location(result, "utf-8")
      end
    end

  }

  local servers = {
    gopls = true,

    golangci_lint_ls = true,

    gdscript = true,

    jsonls = true,

    emmet_language_server = true,

    zls = true,

    eslint = {
      settings = {
        experimental = {
          useFlatConfig = false
        }
      }
    },

    ocamllsp = {
      settings = {
        codelens = { enable = true }
      }
    },

    lua_ls = {
      on_attach = common_on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              [vim.fn.expand "$VIMRUNTIME/lua"] = true,
              [vim.fn.stdpath "config" .. "/lua"] = true,
            },
          },
        },
      },
    },

    tailwindcss = {
      settings = {
        tailwindCSS = {
          experimental = {
            classRegex = {
              { "([\"'`][^\"'`]*.*?[\"'`])", "[\"'`]([^\"'`]*).*?[\"'`]" },
              { "tv\\(([^)]*)\\)",           "[\"'`]([^\"'`]*).*?[\"'`]" },
              { "Styles \\=([^;]*);",        "'([^']*)'" },
              { "Styles \\=([^;]*);",        "\"([^\"]*)\"" },
              { "Styles \\=([^;]*);",        "\\`([^\\`]*)\\`" }
            }
          }
        }
      }
    },
    phpactor = true,
    intelephense = true,
    gleam = true

  }

  local setup_server = function(server, config)
    if not config then
      return
    end

    if type(config) ~= "table" then
      config = {}
    end

    config = vim.tbl_deep_extend("force", {
      on_attach = common_on_attach,
      capabilities = capabilities,
      handlers = handlers
    }, config)
    lspconfig[server].setup(config)
  end

  for server, config in pairs(servers) do
    setup_server(server, config)
  end

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

  local function filterReactDTS(value)
    if value == nil or value.targetUri == nil then
      -- tprint(value)
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


  require('lspconfig')['ts_ls'].setup({
    capabilities = capabilities,
    handlers = merge(handlers, typescript_handlers),
    on_attach = function(client, bufnr)
      common_on_attach(client, bufnr)
      vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", "",
        {
          silent = true,
          callback = function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { "source.removeUnusedImports.ts" },
                diagnostics = {},
              },
            })
            -- vim.api.nvim_command [[ silent! EslintFixAll ]]
          end
        })
    end,
    settings = {
      -- typescript = {
      --   inlayHints = {
      --     includeInlayParameterNameHints = 'none',
      --     includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      --     includeInlayFunctionParameterTypeHints = false,
      --     includeInlayVariableTypeHints = false,
      --     includeInlayVariableTypeHintsWhenTypeMatchesName = false,
      --     includeInlayPropertyDeclarationTypeHints = false,
      --     includeInlayFunctionLikeReturnTypeHints = true,
      --     includeInlayEnumMemberValueHints = true,
      --   }
      -- },
      -- javascript = {
      --   inlayHints = {
      --     includeInlayParameterNameHints = 'all',
      --     includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      --     includeInlayFunctionParameterTypeHints = true,
      --     includeInlayVariableTypeHints = false,
      --     includeInlayVariableTypeHintsWhenTypeMatchesName = false,
      --     includeInlayPropertyDeclarationTypeHints = true,
      --     includeInlayFunctionLikeReturnTypeHints = true,
      --     includeInlayEnumMemberValueHints = true,
      --   }
      -- }
    }
  })
end -- func M.setup()

return M
