-- Multi-terminal manager
-- https://github.com/akinsho/toggleterm.nvim
return {
  "akinsho/toggleterm.nvim",
  keys = {
    { "<leader>t1", "<cmd>1ToggleTerm<cr>", desc = "[T]erminal [1]" },
    { "<leader>t2", "<cmd>2ToggleTerm<cr>", desc = "[T]erminal [2]" },
    { "<leader>t3", "<cmd>3ToggleTerm<cr>", desc = "[T]erminal [3]" },
    { "<leader>ts", "<cmd>TermSelect<cr>", desc = "[T]erminal [S]elect" },
    { "<leader>tx", "<cmd>bd!<cr>", desc = "[T]erminal kill" },
  },
  config = function()
    require("toggleterm").setup({
      hide_numbers = true,
      shade_terminals = false,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = false,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "rounded",
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
        winblend = 0,
      },
      on_open = function(term)
        local buf = term.bufnr
        -- Esc exits terminal mode (buffer-local, so lazygit is unaffected)
        vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = buf, desc = "Exit terminal mode" })
        -- Hide terminal while staying in terminal mode
        vim.keymap.set("t", "<leader>t1", "<C-\\><C-n><cmd>1ToggleTerm<cr>", { buffer = buf, desc = "[T]erminal [1]" })
        vim.keymap.set("t", "<leader>t2", "<C-\\><C-n><cmd>2ToggleTerm<cr>", { buffer = buf, desc = "[T]erminal [2]" })
        vim.keymap.set("t", "<leader>t3", "<C-\\><C-n><cmd>3ToggleTerm<cr>", { buffer = buf, desc = "[T]erminal [3]" })
      end,
    })
  end,
}
