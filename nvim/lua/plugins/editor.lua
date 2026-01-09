return {
	-- Treesitter: Better syntax highlighting and text objects
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		main = "nvim-treesitter.configs",
		opts = {
			ensure_installed = {
				"lua",
				"vim",
				"bash",
				"markdown",
				"python",
				"rust",
				"go",
				"json",
				"yaml",
				"c",
				"cpp",
				"cmake",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = {
				enable = true,
			},
		},
	},

	-- Treesitter Context: Show function/class context
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},

	-- Comment.nvim: Toggle comments
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		keys = {
			{ "gcc", mode = "n", desc = "Comment toggle current line" },
			{ "gbc", mode = "n", desc = "Comment toggle current block" },
		},
		opts = {},
	},

	-- Rainbow delimiters: Colorize nested brackets
	{
		"hiphish/rainbow-delimiters.nvim",
		event = "VeryLazy",
	},

	-- Indent blankline: Show indentation guides
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "VeryLazy",
		main = "ibl",
		opts = {
			indent = {
				char = "┊",
			},
		},
	},

	-- Illuminate: Highlight word under cursor
	{
		"RRethy/vim-illuminate",
		event = "VeryLazy",
		config = function()
			require("illuminate").configure({
				delay = 200,
				under_cursor = true,
			})
		end,
	},

	-- Which-key: Show keybinding hints
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			preset = "helix",
			icons = {
				rules = false,
			},
		},
	},

	-- Symbol Usage: Highlight symbol usage in the buffer
	{
		"Wansmer/symbol-usage.nvim",
		event = "BufReadPre",
		config = function()
			require("symbol-usage").setup()
		end,
	},
}
