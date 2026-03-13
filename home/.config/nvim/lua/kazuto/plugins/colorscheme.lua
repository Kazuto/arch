local api = vim.api

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      vim.cmd("colorscheme catppuccin")

      api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = "#313244" })

      api.nvim_set_hl(0, "IndentBlanklineChar", {
        fg = api.nvim_get_hl(0, { name = "LineNr" }).fg,
      })

      local mocha = require("catppuccin.palettes").get_palette("mocha")

      api.nvim_set_hl(0, "RainbowRed", { fg = mocha.red })
      api.nvim_set_hl(0, "RainbowYellow", { fg = mocha.yellow })
      api.nvim_set_hl(0, "RainbowBlue", { fg = mocha.blue })
      api.nvim_set_hl(0, "RainbowOrange", { fg = mocha.peach })
      api.nvim_set_hl(0, "RainbowGreen", { fg = mocha.green })
      api.nvim_set_hl(0, "RainbowViolet", { fg = mocha.mauve })
      api.nvim_set_hl(0, "RainbowCyan", { fg = mocha.sky })
    end,
  },
  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require("nvim-highlight-colors").setup({
        render = "virtual",
        virtual_symbol = "●",
        virtual_symbol_prefix = "",
        virtual_symbol_suffix = " ",
        virtual_symbol_position = "inline",
        enable_hex = true, -- Highlight hex colors, e.g. '#FFFFFF'
        enable_short_hex = true, -- Highlight short hex colors e.g. '#f90'
        enable_rgb = true, -- Highlight rgb colors, e.g. 'rgb(0 0 0)'
        enable_hsl = true, -- Highlight hsl colors, e.g. 'hsl(150deg 30% 40%)'
        enable_var_usage = true, --Highlight CSS variables, e.g. 'var(--testing-color)'
        enable_named_colors = true, -- Highlight named colors, e.g. 'color: green'
        enable_tailwind = true, -- Highlight tailwind colors, e.g. 'bg-blue-500'
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local todo = require("todo-comments")

      todo.setup({
        signs = true,
        sign_priority = 8,
        keywords = {
          FIX = {
            icon = " ",
            color = "error",
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
          },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          TODO = { icon = " ", color = "info" },
          NOTE = { icon = " ", color = "hint" },
        },
        gui_style = {
          fg = "NONE",
          bg = "BOLD",
        },
        merge_keywords = true,
        highlight = {
          multiline = true,
          multiline_pattern = "^.",
          multiline_context = 10,
          before = "fg",
          keyword = "wide",
          after = "fg",
          pattern = [[.*<(KEYWORDS)\s*:]],
          comments_only = true,
          max_line_len = 400,
          exclude = {},
        },
        colors = {
          error = { "DiagnosticError", "ErrorMsg", "#f38ba8" },
          warning = { "DiagnosticWarn", "WarningMsg", "#fab387" },
          info = { "DiagnosticInfo", "#89b4fa" },
          hint = { "DiagnosticHint", "#a6e3a1" },
          default = { "Identifier", "#cba6f7" },
          test = { "Identifier", "#f5c2e7" },
        },
        search = {
          command = "rg",
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
          },
          pattern = [[\b(KEYWORDS):]],
        },
      })
    end,
  },
}
