return {
	"kdheepak/lazygit.nvim",
	lazy = true,
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	dependencies = {
        "nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
	},
	config = function()
        require("telescope").load_extension("lazygit")
		vim.keymap.set("n", "<leader>gg", function()
			vim.cmd("LazyGit")
		end, {
			desc = "Open LazyGit",
		})
	end,
}
