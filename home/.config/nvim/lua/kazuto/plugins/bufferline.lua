-- A snazzy buffer line (with tabpage integration) for Neovim built using lua.
-- https://github.com/akinsho/bufferline.nvim
return {
  "akinsho/bufferline.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<Tab>",
      function()
        if vim.bo.buftype ~= "terminal" then
          vim.cmd("BufferLineCycleNext")
        end
      end,
      desc = "Next Buffer",
    },
    {
      "<S-Tab>",
      function()
        if vim.bo.buftype ~= "terminal" then
          vim.cmd("BufferLineCyclePrev")
        end
      end,
      desc = "Previous Buffer",
    },
    { "<leader>bd", ":BufferKill<CR>", desc = "Close Buffer" }, -- Changed from <C-w>
    { "<leader>ba", ":BufferKillOthers<CR>", desc = "Close All Other Buffers" },
    { "<leader>bp", ":BufferLinePick<CR>", desc = "Pick Buffer" },
  },
  config = function()
    require("bufferline").setup({
      options = {
        indicator = {
          icon = " ",
        },
        show_close_icon = true,
        tab_size = 0,
        max_name_length = 25,
        offsets = {
          {
            filetype = "NvimTree",
            text = "  Files",
            highlight = "StatusLine",
            text_align = "left",
          },
        },
        hover = {
          enabled = true,
          delay = 0,
          reveal = { "close" },
        },
        modified_icon = "",
        custom_areas = {
          left = function()
            return {
              { text = "    ", fg = "#8fff6d" },
            }
          end,
        },
        diagnostics = "nvim_lsp",
        vim.diagnostic.config({ update_in_insert = true }),
        diagnostics_update_on_event = true,
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return icon .. count
        end,
        highlights = {
          fill = {
            bg = { attribute = "bg", highlight = "StatusLine" },
          },
          buffer_selected = {
            italic = false,
          },
          separator = {
            fg = { attribute = "bg", highlight = "StatusLine" },
            bg = { attribute = "bg", highlight = "BufferlineInactive" },
          },
        },
      },
    })
  end,
}
