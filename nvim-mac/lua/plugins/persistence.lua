return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	config = function()
		require("persistence").setup({
			dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
			options = { "buffers", "curdir", "tabpages", "winsize" },
			pre_save = nil,
			save_empty = false,
		})

		-- Restore last session on startup (if exists)
		vim.api.nvim_create_autocmd("VimEnter", {
			nested = true,
			callback = function()
				local Session = require("persistence")
				-- Only restore if no file args were passed
				if vim.fn.argc(-1) == 0 then
					Session.load()
				end
			end,
		})

		-- Convenient keymaps
		vim.keymap.set("n", "<leader>ps", function() require("persistence").load() end, { desc = "Persistence: restore session" })
		vim.keymap.set("n", "<leader>pl", function() require("persistence").load({ last = true }) end, { desc = "Persistence: restore last session" })
		vim.keymap.set("n", "<leader>pd", function() require("persistence").stop() end, { desc = "Persistence: don't save session" })
	end,
}
