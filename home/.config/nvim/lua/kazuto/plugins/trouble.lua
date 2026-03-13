-- A pretty list for showing diagnostics, references, telescope results, quickfix and location lists to help you solve all the trouble your code is causing.
-- https://github.com/folke/trouble.nvim
return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
  opts = {
    focus = true,
  },
  cmd = "Trouble",
  keys = {
    {
      "<leader>xw",
      ":Trouble diagnostics toggle<CR>",
      desc = "Open trouble workspace diagnostics",
    },
    {
      "<leader>xd",
      ":Trouble diagnostics toggle filter.buf=0<CR>",
      desc = "Open trouble document diagnostics",
    },
    { "<leader>xq", ":Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
    { "<leader>xl", ":Trouble loclist toggle<CR>", desc = "Open trouble location list" },
    { "<leader>xt", ":Trouble todo toggle<CR>", desc = "Open todos in trouble" },
    -- QWERTZ-friendly navigation within Trouble
    {
      "<leader>tn",
      function()
        local trouble = require("trouble")
        if trouble.is_open() then
          trouble.next({ skip_groups = true, jump = true })
        end
      end,
      desc = "Next Trouble Item",
    },
    {
      "<leader>tp",
      function()
        local trouble = require("trouble")
        if trouble.is_open() then
          trouble.previous({ skip_groups = true, jump = true })
        end
      end,
      desc = "Previous Trouble Item",
    },
  },
}
