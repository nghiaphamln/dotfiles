return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
		local shell = is_windows and "pwsh -NoExit" or vim.o.shell
		require("toggleterm").setup({
			size = 20,
			open_mapping = [[<c-\>]],
			hide_numbers = true,
			shade_filetypes = {},
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			persist_size = true,
			direction = "float",
			close_on_exit = true,
			shell = shell,
		})
	end,
}
