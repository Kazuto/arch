-- A framework for interacting with tests within NeoVim
-- https://github.com/nvim-neotest/neotest
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "olimorris/neotest-phpunit",
    "nvim-neotest/neotest-go",
    "marilari88/neotest-vitest",
  },
  keys = {
    { "<leader>tr", "<cmd>lua require('neotest').run.run()<cr>", desc = "Test: Run Nearest" },
    { "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "Test: Run File" },
    { "<leader>ta", "<cmd>lua require('neotest').run.run(vim.fn.getcwd())<cr>", desc = "Test: Run All" },
    { "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Test: Toggle Summary" },
    { "<leader>to", "<cmd>lua require('neotest').output.open({ enter = true })<cr>", desc = "Test: Show Output" },
    { "<leader>tp", "<cmd>lua require('neotest').output_panel.toggle()<cr>", desc = "Test: Toggle Output Panel" },
  },
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("neotest").setup({
      adapters = {
        require("neotest-phpunit")({
          phpunit_cmd = function()
            return "vendor/bin/phpunit"
          end,
        }),
        require("neotest-go")({
          experimental = {
            test_table = true,
          },
        }),
        require("neotest-vitest")({
          filter_dir = function(name)
            return name ~= "node_modules"
          end,
        }),
      },
    })
  end,
}
