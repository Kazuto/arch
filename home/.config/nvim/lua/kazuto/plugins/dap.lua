-- Debug Adapter Protocol client implementation for Neovim
-- https://github.com/mfussenegger/nvim-dap
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "leoluz/nvim-dap-go",
    "theHamsta/nvim-dap-virtual-text",
  },
  keys = {
    { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Debug: Toggle Breakpoint" },
    { "<leader>dc", "<cmd>DapContinue<cr>", desc = "Debug: Continue" },
    { "<leader>di", "<cmd>DapStepInto<cr>", desc = "Debug: Step Into" },
    { "<leader>do", "<cmd>DapStepOver<cr>", desc = "Debug: Step Over" },
    { "<leader>dO", "<cmd>DapStepOut<cr>", desc = "Debug: Step Out" },
    { "<leader>dt", "<cmd>DapTerminate<cr>", desc = "Debug: Terminate" },
    { "<leader>du", "<cmd>lua require('dapui').toggle()<cr>", desc = "Debug: Toggle UI" },
    { "<leader>de", "<cmd>lua require('dapui').eval()<cr>", desc = "Debug: Eval", mode = { "n", "v" } },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()
    require("dap-go").setup()
    require("nvim-dap-virtual-text").setup({
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
    })

    -- PHP/Xdebug configuration
    dap.adapters.php = {
      type = "executable",
      command = "node",
      args = { vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js" },
    }

    dap.configurations.php = {
      {
        type = "php",
        request = "launch",
        name = "Listen for Xdebug",
        port = 9003,
        pathMappings = {
          ["/var/www/html"] = "${workspaceFolder}",
        },
      },
    }

    -- Auto-open/close UI
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Custom signs
    vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })
  end,
}
