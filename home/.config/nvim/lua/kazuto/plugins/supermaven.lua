return {
  "supermaven-inc/supermaven-nvim",
  config = function()
    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<C-CR>",
        clear_suggestion = "<C-]>",
        accept_word = "<C-j>",
      },
      disable_inline_completion = false, -- disables inline completion for use with cmp
    })
  end,
}
