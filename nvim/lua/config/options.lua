-- Basic Vim Options
local opt = vim.opt
local g = vim.g

-- Leader key
g.mapleader = " "
g.maplocalleader = "\\"

-- Display
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Indentation
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Windows
opt.splitbelow = true
opt.splitright = true
opt.wrap = false

-- Behavior
opt.mouse = "a"
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.config/nvim/undo"
opt.swapfile = false
opt.backup = false
opt.clipboard = "unnamedplus"

-- Colors
opt.termguicolors = true

-- Disable optional providers (suppress warnings)
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
