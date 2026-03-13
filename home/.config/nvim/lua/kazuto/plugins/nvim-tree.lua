-- File explorer
-- https://github.com/nvim-tree/nvim-tree.lua
local HEIGHT_RATIO = 0.8 -- You can change this
local WIDTH_RATIO = 0.5 -- You can change this too

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local nvimtree = require("nvim-tree")

    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup({
      disable_netrw = true,
      hijack_netrw = true,
      open_on_tab = false,
      hijack_cursor = false,
      update_cwd = true,
      hijack_directories = {
        enable = true,
        auto_open = true,
      },
      diagnostics = {
        enable = true,
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        },
      },
      -- update_focused_file = {
      -- 	enable = true,
      -- 	update_cwd = true,
      -- 	ignore_list = {},
      -- },
      git = {
        enable = true,
        ignore = false,
        timeout = 500,
      },
      -- Side bar
      -- view = {
      -- 	width = 30,
      -- 	adaptive_size = true,
      -- 	relativenumber = true,
      -- },
      -- Floating center
      view = {
        float = {
          enable = true,
          open_win_config = function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            local window_w = screen_w * WIDTH_RATIO
            local window_h = screen_h * HEIGHT_RATIO
            local window_w_int = math.floor(window_w)
            local window_h_int = math.floor(window_h)
            local center_x = (screen_w - window_w) / 2
            local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
            return {
              border = "rounded",
              relative = "editor",
              row = center_y,
              col = center_x,
              width = window_w_int,
              height = window_h_int,
            }
          end,
        },
        width = function()
          return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
        end,
      },
      renderer = {
        highlight_git = true,
        root_folder_modifier = ":t",
        root_folder_label = false,
        group_empty = true,
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = false,
            git = true,
          },
          glyphs = {
            default = "",
            symlink = "",
            git = {
              unstaged = "",
              staged = "S",
              unmerged = "",
              renamed = "➜",
              deleted = "",
              untracked = "U",
              ignored = "◌",
            },
            folder = {
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
            },
          },
        },
        indent_markers = {
          enable = true,
          inline_arrows = true,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            none = " ",
          },
        },
      },
    })
  end,
  keys = {
    { "<leader>ee", ":NvimTreeToggle<CR>", desc = "Toggle file explorer" },
    { "<leader>ef", ":NvimTreeFindFileToggle<CR>", desc = "Toggle file explorer on current file" },
    { "<leader>ec", ":NvimTreeCollapse<CR>", desc = "Collapse file explorer" },
    { "<leader>er", ":NvimTreeRefresh<CR>", desc = "Refresh file explorer" },
  },
}
