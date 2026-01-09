return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {},
	keys = {
		{
			";",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash",
		},
		{
			"<c-space>",
			mode = { "n", "o", "x" },
			function()
				require("flash").treesitter({
					actions = {
						["<c-space>"] = "next",
						["<BS>"] = "prev",
					},
				})
			end,
			desc = "Treesitter Selection",
		},
	},
}
