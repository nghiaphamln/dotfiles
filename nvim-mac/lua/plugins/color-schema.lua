return {
	"catppuccin/nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			-- variant = "auto",
			-- transparent = true,
			flavour = "mocha",
			background = {
				light = "latte",
				dark = "mocha",
			},
			transparent_background = false,
		})
		vim.cmd([[colorscheme catppuccin]])
	end,
}
