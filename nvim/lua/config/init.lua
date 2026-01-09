-- Config Initialization Module
-- This file orchestrates the loading of all configuration modules

local M = {}

function M.setup()
	-- Load options first (before lazy.nvim initialization)
	require("config.options")

	-- Initialize lazy.nvim plugin manager
	require("config.lazy")

	-- Load utilities
	require("config.utils")

	-- Load keymaps and autocmds after plugins load
	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy",
		callback = function()
			require("config.keymaps")
			require("config.autocmds")
		end,
	})
end

return M
