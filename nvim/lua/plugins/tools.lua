-- Miscellaneous Tools: Terminal, Markdown, Crates
return {
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
