-- Super fast git decorations
-- https://github.com/lewis6991/gitsigns.nvim
return {
  "lewis6991/gitsigns.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("gitsigns").setup({
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 100,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },
      max_file_length = 40000, -- Disable for files longer than 40k lines
      update_debounce = 200, -- Debounce updates
      preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    })
  end,
  keys = {
    { "<leader>gp", ":Gitsigns prev_hunk<CR>", desc = "[G]o to [P]revious Hunk" },
    { "<leader>gn", ":Gitsigns next_hunk<CR>", desc = "[G]o to [N]ext Hunk" },
    { "<leader>hp", ":Gitsigns preview_hunk<CR>", desc = "[H]unk [P]review" },
    { "<leader>hr", ":Gitsigns reset_hunk<CR>", desc = "[H]unk [R]eset" },
    { "<leader>hS", ":Gitsigns stage_buffer<CR>", desc = "[S]tage [B]uffer" },
    { "<leader>hs", ":Gitsigns stage_hunk<CR>", desc = "[H]unk [S]tage" },
    { "<leader>hu", ":Gitsigns undo_stage_hunk<CR>", desc = "[H]unk [U]ndo Stage" },
  },
  event = { "VeryLazy" },
}
