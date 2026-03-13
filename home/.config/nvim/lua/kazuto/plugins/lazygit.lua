return {
  "kdheepak/lazygit.nvim",
  lazy = true,
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  -- optional for floating window border decoration
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- setting the keybinding for LazyGit with 'keys' is recommended in
  -- order to load the plugin when the command is run for the first time
  keys = {
    { "<F2>", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
  },
  config = function()
    vim.g.lazygit_config_file_path = vim.fn.expand("~/.config/lazygit/config.yml")

    -- Re-enter terminal mode whenever a lazygit buffer is focused
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*lazygit*",
      callback = function()
        if vim.bo.buftype == "terminal" then
          vim.cmd("startinsert")
        end
      end,
    })
  end,
}
