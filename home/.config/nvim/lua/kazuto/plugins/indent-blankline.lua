-- This plugin adds indentation guides to Neovim.
-- https://github.com/lukas-reineke/indent-blankline.nvim
return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  main = "ibl",
  config = function()
    local highlight = {
      "RainbowRed",
      "RainbowYellow",
      "RainbowBlue",
      "RainbowOrange",
      "RainbowGreen",
      "RainbowViolet",
      "RainbowCyan",
    }

    require("ibl").setup({
      indent = {
        char = "┊",
        highlight = highlight,
      },
      exclude = {
        filetypes = {
          "dashboard",
        },
      },
      scope = {
        enabled = false,
        show_start = false,
        show_end = false,
      },
    })
  end,
}
