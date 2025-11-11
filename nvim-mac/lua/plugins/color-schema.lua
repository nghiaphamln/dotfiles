return {
	"catppuccin/nvim",
    lazy = false,
	priority = 1000,
	config = function()
        require("catppuccin").setup({
            variant = "auto",
            transparent = true,
        })
		vim.cmd([[colorscheme catppuccin]])
	end,
}
