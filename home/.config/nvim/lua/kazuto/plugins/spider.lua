-- Spider.nvim - smarter w, e, b motions that skip punctuation
-- https://github.com/chrisgrieser/nvim-spider
return {
  "chrisgrieser/nvim-spider",
  lazy = true,
  keys = {
    {
      "w",
      "<cmd>lua require('spider').motion('w')<CR>",
      mode = { "n", "o", "x" },
      desc = "Spider-w",
    },
    {
      "e",
      "<cmd>lua require('spider').motion('e')<CR>",
      mode = { "n", "o", "x" },
      desc = "Spider-e",
    },
    {
      "b",
      "<cmd>lua require('spider').motion('b')<CR>",
      mode = { "n", "o", "x" },
      desc = "Spider-b",
    },
  },
  opts = {
    skipInsignificantPunctuation = true,
    consistentOperatorPending = false,
    subwordMovement = true,
    customPatterns = {},
  },
}
