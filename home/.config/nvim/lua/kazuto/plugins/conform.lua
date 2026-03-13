-- Lightweight yet powerful formatter plugin for Neovim
-- https://github.com/stevearc/conform.nvim
return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        blade = { "blade-formatter" },
        css = { "prettierd" },
        go = { "goimports", "gofumpt" },
        html = { "prettierd" },
        javascript = { "prettierd" },
        json = { "prettierd" },
        lua = { "stylua" },
        markdown = { "prettierd" },
        php = { "pint", "php-cs-fixer", stop_after_first = true },
        python = { "isort", "black" },
        scss = { "prettierd" },
        sh = { "shfmt" }, -- This is what you need for shell files
        bash = { "shfmt" }, -- Also for bash files
        typescript = { "prettierd" },
        vue = { "prettierd" },
        yaml = { "prettierd" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
