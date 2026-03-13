-- Fuzzy finder
-- https://github.com/nvim-telescope/telescope.nvim
return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-smart-history.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-tree/nvim-web-devicons",
    "jonarrien/telescope-cmdline.nvim",
    "tami5/sqlite.lua",
  },
  config = function()
    -- Configure sqlite path for NixOS
    local sqlite_path = vim.env.SQLITE_CLIB_PATH or "/run/current-system/sw/lib/libsqlite3.so"
    if vim.fn.filereadable(sqlite_path) == 1 then
      vim.g.sqlite_clib_path = sqlite_path
    end

    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")

    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        mappings = {
          i = {
            ["<esc>"] = actions.close,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "vendor/",
          "%.lock",
          "dist/",
          "build/",
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
        live_grep = {
          additional_args = function()
            return { "--hidden" }
          end,
        },
        lsp_definitions = {
          show_line = false,
          trim_text = true,
        },
        lsp_references = {
          show_line = false,
          trim_text = true,
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("smart_history")
    telescope.load_extension("ui-select")
    telescope.load_extension("cmdline")

    vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
    vim.keymap.set("n", "fb", builtin.buffers, { desc = "[F]ind existing [B]uffers" })
    vim.keymap.set("v", "fb", function()
      local text = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
      builtin.current_buffer_fuzzy_find({ default_text = table.concat(text, "\n") })
    end, { desc = "[F]ind in current [B]uffer" })
    vim.keymap.set("n", "ff", builtin.find_files, { desc = "[F]ind [F]iles" })
    vim.keymap.set("n", "fa", function()
      builtin.find_files({ follow = true, no_ignore = true, hidden = true })
    end, { desc = "[F]ind [A]ll" })
    vim.keymap.set("n", "fs", builtin.live_grep, { desc = "[F]ind [S]tring" })
    vim.keymap.set("v", "fs", function()
      local text = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
      builtin.grep_string({ search = table.concat(text, "\n") })
    end, { desc = "[F]ind [S]election in project" })
    vim.keymap.set("n", "fg", require("kazuto.plugins.telescope.multigrep"), { desc = "[F]ind [G]rep" })
    vim.keymap.set("n", "fc", builtin.grep_string, { desc = "[F]ind [C]ursor" })
    vim.keymap.set("n", "ft", "<cmd>TodoTelescope<cr>", { desc = "[F]ind [T]odos" })
    vim.keymap.set("n", "fr", builtin.resume, { desc = "[F]ind [R]esume" })
    vim.keymap.set("n", "fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
    vim.keymap.set("n", "fx", builtin.commands, { desc = "[F]ind E[x]ecute Command" })
    vim.keymap.set("n", "Q", builtin.command_history, { desc = "Cmdline" })
  end,
}
