-- Parsers and queries for Neovim's built-in treesitter
-- https://github.com/nvim-treesitter/nvim-treesitter
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main", -- master is frozen and does not support Neovim 0.12
  lazy = false, -- main does not support lazy-loading
  build = ":TSUpdate",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    local ts = require("nvim-treesitter")

    -- Installing parsers requires the `tree-sitter` CLI and a C compiler
    local ensure_installed = {
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
    }
    local can_install = vim.fn.executable("tree-sitter") == 1
    if can_install then
      ts.install(ensure_installed)
    else
      vim.notify("tree-sitter CLI not found: treesitter parsers can't be installed", vim.log.levels.WARN)
    end

    local max_filesize = 100 * 1024 -- 100 KB
    local indent_disabled = { blade = true } -- Use blade-formatter instead

    local function has_query(lang, name)
      return #vim.treesitter.query.get_files(lang, name) > 0
    end

    local function attach(buf, lang)
      if not vim.treesitter.language.add(lang) then
        return
      end

      local stats = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
      if not (stats and stats.size > max_filesize) and has_query(lang, "highlights") then
        vim.treesitter.start(buf, lang)
      end

      if not indent_disabled[lang] and has_query(lang, "indents") then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      -- Incremental selection using Neovim's built-in `an` and `in`
      vim.keymap.set("n", "<C-n>", "van", { buffer = buf, remap = true, desc = "Start node selection" })
      vim.keymap.set("x", "<C-n>", "an", { buffer = buf, remap = true, desc = "Expand node selection" })
      vim.keymap.set("x", "<bs>", "in", { buffer = buf, remap = true, desc = "Shrink node selection" })
    end

    local attempted = {}
    for _, lang in ipairs(ensure_installed) do
      attempted[lang] = true
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("kazuto_treesitter", { clear = true }),
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then
          return
        end

        -- Automatically install missing parsers when entering buffer
        if
          can_install
          and not attempted[lang]
          and not vim.list_contains(ts.get_installed("parsers"), lang)
          and vim.list_contains(ts.get_available(), lang)
        then
          attempted[lang] = true
          ts.install({ lang }):await(vim.schedule_wrap(function()
            if vim.api.nvim_buf_is_valid(args.buf) then
              attach(args.buf, lang)
            end
          end))
        end

        attach(args.buf, lang)
      end,
    })
  end,
}
