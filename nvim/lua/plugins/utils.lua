-- Utility Plugins: Telescope, LazyGit, Terminal, Dashboard

return {
	-- Telescope: Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
			{ "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "Find Word" },
			{ "<leader><leader>", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
		},
		opts = {
			defaults = {
				file_ignore_patterns = { "node_modules", ".git/", "dist/" },
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						preview_width = 0.65,
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					find_command = { "rg", "--files", "--hidden", "--glob", "!.git" },
				},
			},
		},
	},

	-- LazyGit: Git client
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = "LazyGit",
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
		dependencies = { "nvim-lua/plenary.nvim" },
	},

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
