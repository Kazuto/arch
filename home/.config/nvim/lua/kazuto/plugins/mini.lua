local comment = {
  "echasnovski/mini.comment",
  event = "VeryLazy",
  config = function()
    require("mini.comment").setup({})
  end,
}

local cursorword = {
  "echasnovski/mini.cursorword",
  event = "VeryLazy",
  config = function()
    require("mini.cursorword").setup({})
  end,
}

local move = {
  "echasnovski/mini.move",
  event = "VeryLazy",
  mappings = {
    -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
    left = "<M-h>",
    right = "<M-l>",
    down = "<M-j>",
    up = "<M-k>",

    -- Move current line in Normal mode
    line_left = "<M-h>",
    line_right = "<M-l>",
    line_down = "<M-j>",
    line_up = "<M-k>",
  },

  -- Options which control moving behavior
  config = function()
    require("mini.move").setup({
      -- Automatically reindent selection during linewise vertical move
      reindent_linewise = true,
    })
  end,
}

local splitjoin = {
  "echasnovski/mini.splitjoin",
  event = "VeryLazy",
  config = function()
    vim.g.splitjoin_html_attributes_bracket_on_new_line = 1
    vim.g.splitjoin_trailing_comma = 1
    vim.g.splitjoin_php_method_chain_full = 1

    require("mini.splitjoin").setup({})
  end,
}

local surround = {
  "echasnovski/mini.surround",
  event = "VeryLazy",
  config = function()
    require("mini.surround").setup({})
  end,
}

return {
  comment,
  cursorword,
  move,
  splitjoin,
  surround,
}
