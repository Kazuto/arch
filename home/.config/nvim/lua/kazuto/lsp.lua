vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local map = function(mode, keys, func, desc)
      vim.keymap.set(
        mode,
        keys,
        func,
        { noremap = true, silent = true, buffer = ev.buf, desc = desc }
      )
    end

    -- Navigation (primarily Intelephense)
    map("n", "gD", function()
      local clients = vim.lsp.get_clients({ bufnr = ev.buf })
      local supports_declaration = vim.iter(clients):any(function(c)
        return c.supports_method("textDocument/declaration")
      end)
      if supports_declaration then
        vim.lsp.buf.declaration()
      else
        vim.lsp.buf.definition()
      end
    end, "Go to Declaration")
    map("n", "gd", function()
      -- Check if we're in a special buffer type that might cause issues
      local buftype = vim.bo.buftype
      if buftype == "prompt" or buftype == "nofile" then
        vim.notify("Cannot navigate from this buffer type", vim.log.levels.WARN)
        return
      end

      -- Try Telescope first, fallback to builtin LSP
      local ok, _ = pcall(function()
        require("telescope.builtin").lsp_definitions({
          show_line = false,
          trim_text = true,
          include_current_line = false,
        })
      end)

      if not ok then
        -- Fallback to builtin LSP
        vim.lsp.buf.definition()
      end
    end, "Go to Definition")
    map("n", "gr", "<cmd>Telescope lsp_references<CR>", "Go to References")
    map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", "Go to Implementation")
    map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Go to Type Definition")

    -- Documentation (Intelephense)
    map("n", "K", vim.lsp.buf.hover, "Show Hover Documentation")

    -- Refactoring (will use whichever server supports it)
    map("n", "grn", vim.lsp.buf.rename, "Smart rename")
    map({ "n", "v" }, "gra", vim.lsp.buf.code_action, "Code Actions")

    -- Diagnostics
    map("n", "<leader>d", vim.diagnostic.open_float, "Show Line Diagnostics")
    map("n", "<leader>dp", function()
      vim.diagnostic.jump({ count = -1 })
    end, "Previous Diagnostic")
    map("n", "<leader>dn", function()
      vim.diagnostic.jump({ count = 1 })
    end, "Next Diagnostic")

    -- LSP Servers
    map({ "n" }, "<leader>rs", ":LspRestart<CR>", "[R]estart LSP [S]erver")
  end,
})

local signs = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local severity = vim.diagnostic.severity

vim.diagnostic.config({
  signs = {
    text = {
      [severity.ERROR] = signs.Error,
      [severity.WARN] = signs.Warn,
      [severity.HINT] = signs.Hint,
      [severity.INFO] = signs.Info,
    },
  },
  virtual_text = {
    prefix = "●",
    source = "if_many",
  },
  update_on_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    source = true,
    border = "rounded",
  },
})
