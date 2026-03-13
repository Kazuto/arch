-- A super powerful autopair plugin for Neovim that supports multiple characters.
-- https://github.com/windwp/nvim-autopairs
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
  config = function()
    local autopairs = require("nvim-autopairs")

    autopairs.setup({
      disable_filetype = { "TelescopePrompt" },
      check_ts = true,
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
        java = false,
      },
    })

    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

    local cmp = require("cmp")

    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
