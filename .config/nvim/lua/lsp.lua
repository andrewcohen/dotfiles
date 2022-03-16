local M = {}

function M.setup()
  local nvim_lsp = require('lspconfig')
  local protocol = require('vim.lsp.protocol')

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local common_on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Mappings.
    local opts = { noremap=true, silent=true }

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
    buf_set_keymap('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.setloclist()<CR>', opts)
    buf_set_keymap("n", "<leader>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

    -- formatting
    if client.resolved_capabilities.document_formatting then
      vim.api.nvim_command [[augroup Format]]
      vim.api.nvim_command [[autocmd! * <buffer>]]
      vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
      vim.api.nvim_command [[augroup END]]
    end

    -- require'completion'.on_attach(client, bufnr)

    protocol.CompletionItemKind = {
      '', -- Text
      '', -- Method
      '', -- Function
      '', -- Constructor
      '', -- Field
      '', -- Variable
      '', -- Class
      'ﰮ', -- Interface
      '', -- Module
      '', -- Property
      '', -- Unit
      '', -- Value
      '', -- Enum
      '', -- Keyword
      '﬌', -- Snippet
      '', -- Color
      '', -- File
      '', -- Reference
      '', -- Folder
      '', -- EnumMember
      '', -- Constant
      '', -- Struct
      '', -- Event
      'ﬦ', -- Operator
      '', -- TypeParameter
    }
  end

  local lsp_installer = require("nvim-lsp-installer")

  -- Register a handler that will be called for all installed servers.
  -- Alternatively, you may also register handlers on specific server instances instead (see example below).
  lsp_installer.on_server_ready(function(server)
      local opts = {
        on_attach = common_on_attach,
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
      }


      if server.name == "rust_analyzer" then
        -- Initialize the LSP via rust-tools instead
        require("rust-tools").setup {
          -- The "server" property provided in rust-tools setup function are the
          -- settings rust-tools will provide to lspconfig during init.            --
          -- We merge the necessary settings from nvim-lsp-installer (server:get_default_options())
          -- with the user's own settings (opts).
          server = vim.tbl_deep_extend("force", server:get_default_options(), opts),
        }
        server:attach_buffers()
      elseif server.name == "html" then
        opts.init_options = {
          provideFormatter = false
        }
        -- opts.settings = {
        --   html = {
        --     format = {
        --       wrapLineLength = 240
        --     }
        --   }
        -- }
      elseif server.name == "eslint" then
        opts.on_attach = function (client, bufnr)
            -- neovim's LSP client does not currently support dynamic capabilities registration, so we need to set
            -- the resolved capabilities of the eslint server ourselves!
            client.resolved_capabilities.document_formatting = true
            common_on_attach(client, bufnr)
        end
        opts.settings = {
            format = { enable = true }, -- this will enable formatting
        }
      elseif server.name == "tsserver" then
        -- typescript language server goto definition is kinda busted, so hacks
        -- https://github.com/typescript-language-server/typescript-language-server/issues/216

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
          return string.match(value.uri, 'react/index.d.ts') == nil
        end

        opts.handlers = {
          ['textDocument/definition'] = function(err, result, method, ...)
            if vim.tbl_islist(result) and #result > 1 then
              local filtered_result = filter(result, filterReactDTS)
              return vim.lsp.handlers['textDocument/definition'](err, filtered_result, method, ...)
            end

            vim.lsp.handlers['textDocument/definition'](err, result, method, ...)
          end
        }

  --   -- Needed for inlayHints. Merge this table with your settings or copy
  --   -- it from the source if you want to add your own init_options.
        local init_options = require("nvim-lsp-ts-utils").init_options
        local on_attach = function(client, bufnr)
          common_on_attach(client, bufnr)
          client.resolved_capabilities.document_formatting = false
          client.resolved_capabilities.document_range_formatting = false

          local ts_utils = require("nvim-lsp-ts-utils")

          -- defaults
          ts_utils.setup({
            auto_inlay_hints = false,
          })

          -- required to fix code action ranges and filter diagnostics
          ts_utils.setup_client(client)

          -- no default maps, so you may want to define some here
          local keymap_opts = { silent = true }
          vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", keymap_opts)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", keymap_opts)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", keymap_opts)
        end

        opts.init_options = init_options
        opts.on_attach = on_attach
      end
      server:setup(opts)
  end)


  -- typescript
end

return M
