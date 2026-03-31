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
opt.undodir = vim.fn.stdpath("config") .. "/undo"
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

local function python_user_bin()
	local python = vim.fn.exepath("python3")
	if python == "" then
		return nil
	end

	local lines = vim.fn.systemlist({
		python,
		"-m",
		"site",
		"--user-base",
	})

	if vim.v.shell_error ~= 0 or #lines == 0 then
		return nil
	end

	local user_base = vim.trim(lines[1])
	if user_base == "" then
		return nil
	end

	local bin_dir = user_base .. "/bin"
	if vim.fn.isdirectory(bin_dir) == 1 then
		return bin_dir
	end

	return nil
end

local py_user_bin = python_user_bin()
if py_user_bin and not vim.env.PATH:find(py_user_bin, 1, true) then
	vim.env.PATH = py_user_bin .. ":" .. vim.env.PATH
end
