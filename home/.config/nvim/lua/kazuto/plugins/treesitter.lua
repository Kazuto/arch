-- Treesitter configurations and abstraction layer for Neovim
-- https://github.com/nvim-treesitter/nvim-treesitter
return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function(_, opts)
    vim.filetype.add({
      pattern = {
        [".*%.blade%.php"] = "blade",
      },
    })

    local treesitter = require("nvim-treesitter")
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

    -- Configure blade parser
    parser_config.blade = {
      install_info = {
        url = "https://github.com/EmranMR/tree-sitter-blade",
        files = { "src/parser.c" },
        branch = "main",
      },
      filetype = "blade",
    }

    vim.g.skip_ts_context_commentstring_module = true

    treesitter.setup({
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

    -- Register blade parser
    vim.treesitter.language.register("blade", "blade")

    -- Ensure Treesitter highlighting works for all filetypes
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local buf = args.buf
        -- Check if treesitter parser is available for this filetype
        local ft = vim.bo[buf].filetype
        if ft and ft ~= "" then
          pcall(vim.treesitter.start, buf, ft)
        end
      end,
    })
  end,
}
