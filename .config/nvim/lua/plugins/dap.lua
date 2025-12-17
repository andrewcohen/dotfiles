return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'igorlfs/nvim-dap-view',
    },
    keys = {
      { '<leader>b',  function() require('dap').toggle_breakpoint() end, desc = "Toggle Breakpoint", },
      {
        '<leader>B',
        function()
          vim.ui.input(
            { prompt = "Breakpoint condition: " },
            function(input)
              require("dap").set_breakpoint(input)
            end
          )
        end,
        desc = "Set Conditional Breakpoint",
      },
      { '<leader>dc', function() require('dap').continue() end,          desc = "DAP Continue", },
      { '<leader>do', function() require('dap').step_over() end,         desc = "DAP Step Over", },
      { '<leader>di', function() require('dap').step_into() end,         desc = "DAP Step Into", },
      { '<leader>dI', function() require('dap').step_out() end,          desc = "DAP Step Out", },
      { '<leader>du', function() require('dap-view').toggle() end,       desc = "Toggle DAP View", },
      { '<leader>dS', function() require('dap').disconnect() end,        desc = "DAP Disconnect", },
      { '<leader>dr', function() require('dap').restart() end,           desc = "DAP Restart", },
    },
    config = function()
      local dap, ui = require("dap"), require('dap-view')

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

      ui.setup({
        winbar = {
          default_section = "scopes"
        }
      })

      dap.listeners.after.event_initialized["dapview_config"] = function()
        ui.open()
      end
      dap.listeners.before.event_terminated["dapview_config"] = function()
        ui.close()
      end
      dap.listeners.before.event_exited["dapview_config"] = function()
        ui.close()
      end
    end
  },

  { "theHamsta/nvim-dap-virtual-text" },

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
