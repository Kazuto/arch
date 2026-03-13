-- A blazing fast and easy to configure Neovim statusline written in Lua.
-- https://github.com/nvim-lualine/lualine.nvim

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "arkav/lualine-lsp-progress",
    "nvim-tree/nvim-web-devicons",
    "catppuccin/nvim",
  },
  config = function()
    local mocha = require("catppuccin.palettes").get_palette("mocha")
    vim.opt.laststatus = 0

    require("lualine").setup({
      options = {
        icons_enabled = true,
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
        theme = {
          normal = {
            a = { bg = mocha.base, fg = mocha.text, gui = "bold" },
            b = { bg = mocha.base, fg = mocha.text },
            c = { bg = mocha.base, fg = mocha.text },
          },
          insert = {
            a = { bg = mocha.blue, fg = mocha.base, gui = "bold" },
            b = { bg = mocha.base, fg = mocha.text },
            c = { bg = mocha.base, fg = mocha.text },
          },
          visual = {
            a = { bg = mocha.peach, fg = mocha.base, gui = "bold" },
            b = { bg = mocha.base, fg = mocha.text },
            c = { bg = mocha.base, fg = mocha.text },
          },
          replace = {
            a = { bg = mocha.red, fg = mocha.base, gui = "bold" },
            b = { bg = mocha.base, fg = mocha.text },
            c = { bg = mocha.base, fg = mocha.text },
          },
          command = {
            a = { bg = mocha.green, fg = mocha.base, gui = "bold" },
            b = { bg = mocha.base, fg = mocha.text },
            c = { bg = mocha.base, fg = mocha.text },
          },
          inactive = {
            a = { bg = mocha.base, fg = mocha.text, gui = "bold" },
            b = { bg = mocha.base, fg = mocha.text },
            c = { bg = mocha.base, fg = mocha.text },
          },
        },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100,
        },
      },
      sections = {
        lualine_a = {
          "mode",
        },
        lualine_b = {
          "branch",
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
          },
          function()
            return "󰅭 " .. vim.pesc(tostring(#vim.tbl_keys(vim.lsp.get_clients())) or "")
          end,
          { "diagnostics", sources = { "nvim_diagnostic" } },
        },
        lualine_c = {},
        lualine_x = {
          { "filename", path = 1 },
          -- {
          --   require("lazy.status").updates,
          --   cond = require("lazy.status").has_updates,
          --   color = { fg = "#ff9e64" },
          -- },
        },
        lualine_y = {
          "filetype",
          -- "fileformat",
          -- '(vim.bo.expandtab and "␠ " or "⇥ ") .. vim.bo.shiftwidth',
        },
        lualine_z = {
          "progress",
          "location",
        },
      },
    })
  end,
}
