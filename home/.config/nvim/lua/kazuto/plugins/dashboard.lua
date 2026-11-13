local shortcuts = {
  {
    icon = " ",
    icon_hl = "@variable",
    group = "DashboardShortCut",
    desc = "New File ",
    key = "n",
    key_format = " %s", -- remove default surrounding `[]`
    action = "enew",
  },
  {
    icon = " ",
    icon_hl = "@variable",
    group = "DashboardShortCut",
    desc = "Find File ",
    key = "f",
    key_format = " %s", -- remove default surrounding `[]`
    action = "Telescope find_files cwd=",
  },
  {
    icon = " ",
    icon_hl = "@variable",
    desc = "Find Text ",
    group = "DashboardShortCut",
    key = "F",
    key_format = " %s", -- remove default surrounding `[]`
    action = "Telescope live_grep",
  },
  {
    icon = " ",
    icon_hl = "@variable",
    desc = "Update Plugins ",
    group = "DashboardShortCut",
    key = "u",
    key_format = " %s", -- remove default surrounding `[]`
    action = "Lazy update",
  },
}

-- Fancy and Blazing Fast start screen
-- https://github.com/nvimdev/dashboard-nvim
return {
  "nvimdev/dashboard-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("dashboard").setup({
      config = {
        header = {
          "                                        ",
          "                                        ",
          "        ..............    ......        ",
          "         ............    ......         ",
          "              ................          ",
          "             ................           ",
          "            ......  ....                ",
          "             ....   .....               ",
          "              ..    .....               ",
          "                  ......                ",
          "                 ......                 ",
          "                 .....                  ",
          "                   ..                   ",
          "                                        ",
          "                                        ",
        },
        center = shortcuts,
        packages = { enable = true }, -- show how many plugins neovim loaded
        project = { enable = true, icon = " ", limit = 3 },
        mru = { limit = 3, icon = " ", label = "Recent files", cwd_only = true },
        shortcut = shortcuts,
        footer = { "" },
      },
    })
  end,
  event = "VimEnter",
}
