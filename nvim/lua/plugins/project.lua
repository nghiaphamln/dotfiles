return {
	"ahmedkhalf/project.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("project_nvim").setup({
			detection_methods = { "pattern", "lsp" },
			patterns = { ".git", "Makefile", "package.json", "README.md", "Cargo.toml" },
			-- store project history for quick access
			datapath = vim.fn.stdpath("data"),
		})

		-- Integrate with Telescope to show recent projects
		require("telescope").load_extension("projects")

		-- Keymaps
		vim.keymap.set("n", "<leader>pp", function() vim.cmd("Telescope projects") end, { desc = "Projects: browse recent projects" })
	end,
}
