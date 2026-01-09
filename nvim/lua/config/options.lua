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

-- Diagnostic configuration
vim.diagnostic.config({
	virtual_text = {
		prefix = "●", -- Use a more visible prefix
		spacing = 4,
		source = "if_many", -- Show source only if there are multiple sources
		format = function(diagnostic)
			-- Format diagnostic messages to be more readable
			local severity = diagnostic.severity
			local severity_str = ({
				[vim.diagnostic.severity.ERROR] = "E",
				[vim.diagnostic.severity.WARN] = "W",
				[vim.diagnostic.severity.INFO] = "I",
				[vim.diagnostic.severity.HINT] = "H",
			})[severity] or "?"

			return string.format("[%s] %s", severity_str, diagnostic.message)
		end,
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})

-- Disable optional providers (suppress warnings)
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
