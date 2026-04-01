-- Miscellaneous Tools: Terminal, Markdown, Crates
return {
	-- Toggleterm: Terminal
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		event = "VeryLazy",
		keys = {
			{ "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
		},
		opts = {
			size = 20,
			open_mapping = [[<C-\>]],
			hide_numbers = true,
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			persist_size = true,
			direction = "float",
			close_on_exit = true,
		},
	},

	-- Render Markdown: Better markdown display
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		opts = {},
	},

	-- Crates: Rust dependency manager
	{
		"Saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			null_ls = {
				enabled = true,
				name = "crates.nvim",
			},
		},
	},
}
