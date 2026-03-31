-- Miscellaneous Tools: Terminal, Dashboard, Markdown, Crates
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

	-- Dashboard: Startup screen
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			theme = "hyper",
			config = {
				header = {
					"███╗   ██╗ ██████╗ ██╗  ██╗██╗ █████╗     ██████╗ ███╗   ███╗",
					"████╗  ██║██╔════╝ ██║  ██║██║██╔══██╗    ██╔══██╗████╗ ████║",
					"██╔██╗ ██║██║  ███╗███████║██║███████║    ██████╔╝██╔████╔██║",
					"██║╚██╗██║██║   ██║██╔══██║██║██╔══██║    ██╔═══╝ ██║╚██╔╝██║",
					"██║ ╚████║╚██████╔╝██║  ██║██║██║  ██║    ██║     ██║ ╚═╝ ██║",
					"╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝    ╚═╝     ╚═╝     ╚═╝",
				},
				center = {
					{
						icon = "  ",
						desc = "Recently opened files",
						action = "Telescope oldfiles",
					},
					{
						icon = "  ",
						desc = "Find file",
						action = "Telescope find_files",
					},
					{
						icon = "  ",
						desc = "File explorer",
						action = "Neotree toggle",
					},
					{
						icon = "  ",
						desc = "Find word",
						action = "Telescope live_grep",
					},
					{
						icon = "  ",
						desc = "Open config",
						action = "edit $MYVIMRC",
					},
				},
			},
		},
	},

	-- Render Markdown: Better markdown display
	{
		"MeanderingProgrammer/render-markdown.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			latex = { enabled = false },
		},
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
