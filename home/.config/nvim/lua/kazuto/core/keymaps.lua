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

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

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
keymap("n", "<leader>qn", ":cnext<CR>")
keymap("n", "<leader>qp", ":cprev<CR>")

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

-- For navigating between git changes (if you use vim-fugitive or similar)
keymap("n", "<leader>cp", ":cprevious<CR>", { desc = "Previous Change" })
keymap("n", "<leader>cn", ":cnext<CR>", { desc = "Next Change" })

-- For navigating folds (alternative to zj/zk if you use them)
keymap("n", "<leader>zn", "zj", { desc = "Next Fold" })
keymap("n", "<leader>zp", "zk", { desc = "Previous Fold" })

-- PHPActor restart for memory issues
keymap("n", "<leader>rp", ":PhpactorRestart<CR>", { desc = "[R]estart [P]HPActor" })
