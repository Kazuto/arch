return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- list of servers for mason to install
      ensure_installed = {
        "bashls",
        "cssls",
        "emmet_ls",
        "gopls",
        "html",
        "intelephense",
        "jsonls",
        "lua_ls",
        "phpactor",
        "tailwindcss",
        "ts_ls",
        "vue_ls",
      },
    },
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      {
        "neovim/nvim-lspconfig",
        dependencies = {
          "b0o/schemastore.nvim",
          { "j-hui/fidget.nvim", tag = "legacy", opts = {} },
          "folke/neodev.nvim",
        },
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- All formatters, linters, and LSPs now installed system-wide via install.sh
        -- Only keep tools that aren't available in pacman/AUR
        "php-debug-adapter", -- PHP debugger (not in repos)
      },
    },
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
}
