-- Render markdown in-buffer with styled headings, tables, code blocks, and more
-- https://github.com/MeanderingProgrammer/render-markdown.nvim
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = { "markdown" },
  opts = {},
  keys = {
    { "<leader>tm", "<cmd>RenderMarkdown toggle<cr>", ft = "markdown", desc = "[T]oggle [M]arkdown render" },
  },
}
