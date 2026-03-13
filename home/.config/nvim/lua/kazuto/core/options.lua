local opt = vim.opt
-- Performance
opt.updatetime = 250
opt.timeoutlen = 300
opt.redrawtime = 10000
opt.maxmempattern = 5000
opt.synmaxcol = 300 -- Don't syntax highlight long lines
opt.lazyredraw = true -- Don't redraw during macros
opt.ttyfast = true -- Faster terminal connection

-- Better completion
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10

-- Better search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Better editing
opt.autoindent = true
opt.smartindent = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2

-- Better UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.cursorline = true
opt.title = true
opt.termguicolors = true -- enable 24-bit RGB color
opt.background = "dark" -- dark or light

-- Better file handling
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Better tables
opt.wildmode = "list:longest,list:full" -- list all matches and complete till longest common string

-- SPLIT WINDOWS
opt.splitright = true -- split new window to right
opt.splitbelow = true -- split new window below

-- CONFIRMATION
opt.confirm = true -- ask for confirmation

-- CLIPBOARD
opt.clipboard:append("unnamedplus") -- use system clipboard

-- LISTCHARS
opt.list = true -- enable listchars
opt.listchars = {
  tab = "┊ ",
  trail = "·",
  nbsp = "⎵",
  -- eol = '↲',
  extends = "❯",
  precedes = "❮",
}
