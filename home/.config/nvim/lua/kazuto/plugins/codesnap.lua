return {
  "mistricky/codesnap.nvim",
  tag = "v1.6.3",
  build = "make",
  keys = {
    {
      "<leader>cc",
      "<Esc><cmd>CodeSnap<cr>",
      mode = { "v", "x" },
      desc = "Save selected code snapshot into clipboard",
    },
  },
  config = function()
    require("codesnap").setup({
      save_path = "~/Pictures",
      has_breadcrumbs = true,
      bg_color = "#535c68",
      watermark = "",
      bg_padding = 20,
      has_line_number = true,
    })
  end,
}
