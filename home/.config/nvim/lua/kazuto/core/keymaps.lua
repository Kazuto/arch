-- LEADER (Space)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Shorten function name
local function keymap(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }

  if opts then
    options = vim.tbl_extend("force", options, opts)
  end

  vim.keymap.set(mode, lhs, rhs, options)
end

-- general
keymap("n", "<C-s>", vim.cmd.w, { desc = "[S]ave file" })

-- Better window navigation (removed: use Hyper+hjkl in Hyprland instead)
-- Keeping Ctrl+L free for Supermaven accept suggestion

-- Resize windows
keymap("n", "<C-Up>", ":resize -2<CR>")
keymap("n", "<C-Down>", ":resize +2<CR>")
keymap("n", "<C-Left>", ":vertical resize -2<CR>")
keymap("n", "<C-Right>", ":vertical resize +2<CR>")

-- Better indenting
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Move text up and down
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

-- Navigate between quickfix items
keymap("n", "]q", ":cnext<CR>", { desc = "Next quickfix" })
keymap("n", "[q", ":cprev<CR>", { desc = "Previous quickfix" })

-- When text is wrapped, move by terminal rows, not lines, unless a count is provided
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- split windows
keymap("n", "<leader>sv", "<C-w>v", { desc = "[S]plit window [V]ertical" })
keymap("n", "<leader>sh", "<C-w>s", { desc = "[S]plit window [H]orizontal" })
keymap("n", "<leader>se", "<C-w>=", { desc = "[S]plit window [E]qual" })
keymap("n", "<leader>sx", ":close<CR>", { desc = "[S]plit window E[x]it" })

-- Maintain the cursor position when yanking a visual selection
keymap("v", "y", "myy`y")

-- Better paste (don't replace clipboard)
keymap("v", "p", '"_dP')

-- Clear search highlighting
keymap("n", "<Esc>", function()
  if vim.v.hlsearch == 1 then
    vim.cmd("nohlsearch")
  end
end, { desc = "Clear search highlights", silent = true })

-- Quick save and quit
keymap("n", "<leader>w", ":w<CR>")
keymap("n", "<leader>q", ":q<CR>")
keymap("n", "<leader>x", ":x<CR>")

-- Alternative to [{ and ]} for function/block navigation
keymap("n", "<leader>fp", "?{<CR>", { desc = "Previous {" })
keymap("n", "<leader>fn", "/{<CR>", { desc = "Next {" })

-- Navigate diagnostics (LSP errors/warnings)
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })

-- Navigate buffers
keymap("n", "]b", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "[b", ":bprevious<CR>", { desc = "Previous buffer" })

-- Navigate git hunks (if you use gitsigns)
keymap("n", "]c", function()
  if vim.wo.diff then return ']c' end
  vim.schedule(function() require('gitsigns').next_hunk() end)
  return '<Ignore>'
end, { expr = true, desc = "Next git hunk" })
keymap("n", "[c", function()
  if vim.wo.diff then return '[c' end
  vim.schedule(function() require('gitsigns').prev_hunk() end)
  return '<Ignore>'
end, { expr = true, desc = "Previous git hunk" })

-- Navigate folds
keymap("n", "]z", "zj", { desc = "Next fold" })
keymap("n", "[z", "zk", { desc = "Previous fold" })

-- PHPActor restart for memory issues
keymap("n", "<leader>rp", ":PhpactorRestart<CR>", { desc = "[R]estart [P]HPActor" })
