return {
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require("dap")

      local sign = vim.fn.sign_define
      sign("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      sign("DapBreakpointCondition", { text = "", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      sign("DapLogPoint", { text = "󰍩", texthl = "DapLogPoint", linehl = "", numhl = "" })
      sign("DapStopped", { text = "󰜴", texthl = "DapStopped", linehl = "", numhl = "" })
      sign("DapBreakpointRejected", { text = "󰅙", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })


      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { vim.env.HOME .. "/.local/share/nvim/lazy/vscode-js-debug/dist/src/dapDebugServer.js", "${port}" },
        }
      }
    end
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "theHamsta/nvim-dap-virtual-text", "nvim-neotest/nvim-nio" },
    opts = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      require("nvim-dap-virtual-text").setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  },

  { 'nvim-telescope/telescope-dap.nvim' },

  { 'leoluz/nvim-dap-go' },

  {
    -- this is kind of a weird hack to have Lazy manage this dependency, but it works
    -- required by 'nvim-dap-vscode-js'
    "microsoft/vscode-js-debug",
    build = table.concat({
      "npm ci --legacy-peer-deps",
      "npx gulp dapDebugServer",
      -- keep the plugin repo clean so Lazy can update it later
      "git checkout -- package-lock.json || true"
    }, " && ")
  }
}
