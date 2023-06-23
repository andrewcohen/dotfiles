return {
  {
    'mfussenegger/nvim-dap',
    config = function()
      -- enhanced dap theming for catppuccin
      require("dap")
      local sign = vim.fn.sign_define
      sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
    end
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "theHamsta/nvim-dap-virtual-text" },
    opts = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        -- require 'mappings'.set_normal_mappings()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        -- require 'mappings'.unset_normal_mappings()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        -- require 'mappings'.unset_normal_mappings()
        dapui.close()
      end
    end
  },

  { 'nvim-telescope/telescope-dap.nvim' },

  { 'leoluz/nvim-dap-go' },

  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-vscode-js").setup({
        -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
        debugger_path = vim.env.HOME .. "/.local/share/nvim/lazy/vscode-js-debug",                      -- Path to vscode-js-debug installation.
        -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
        -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
        -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
        -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
      })

      for _, language in ipairs({ "typescript", "javascript" }) do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require 'dap.utils'.pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
        }
      end
    end
  },

  {
    -- this is kind of a weird hack to have Lazy manage this dependency, but it works
    -- required by 'nvim-dap-vscode-js'
    "microsoft/vscode-js-debug",
    build = "git clean -df && npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
  }
}
