-- Treesitter configurations and abstraction layer for Neovim
-- https://github.com/nvim-treesitter/nvim-treesitter
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master", -- Use stable version compatible with Neovim 0.11
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false, -- Disable for better performance
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },

      indent = {
        enable = true,
        disable = { "blade" }, -- Disable for Blade files - use blade-formatter instead
      },

      autopairs = {
        enable = true,
      },

      -- A list of parser names, or "all" (the five listed parsers should always be installed)
      ensure_installed = {
        "bash",
        "blade",
        "css",
        "dockerfile",
        "go",
        "html",
        "javascript",
        "json",
        "markdown",
        "markdown_inline",
        "php",
        "php_only",
        "python",
        "scss",
        "sql",
        "typescript",
        "vue",
        "yaml",
        -- Default
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-n>",
          node_incremental = "<C-n>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
      auto_install = true,
    })
  end,
}
