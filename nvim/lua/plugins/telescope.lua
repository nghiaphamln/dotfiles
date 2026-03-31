-- Telescope: Fuzzy finder
return {
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
}
