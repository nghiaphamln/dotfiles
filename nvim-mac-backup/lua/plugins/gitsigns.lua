return {
	"lewis6991/gitsigns.nvim",
	signs = {
		add = {
			hl = "GitSignsAdd",
			symbol = "▎",
			numhl = "GitSignsAddNr",
			linehl = "GitSignsAddLn",
		},
		change = {
			hl = "GitSignsChange",
			symbol = "▎",
			numhl = "GitSignsChangeNr",
			linehl = "GitSignsChangeLn",
		},
	},
	watch_index = {
		interval = 1000,
		follow_files = true,
	},
	watch_gitdir = {
		interval = 1000,
		follow_files = true,
	},
}
