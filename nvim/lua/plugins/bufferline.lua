return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		vim.opt.termguicolors = true
		require("bufferline").setup({
			options = {
				-- ensure tab indicators and groups are enabled so pinned buffers show their icon
				show_tab_indicators = true,
				groups = {
					-- keep default behaviour but explicitly add a pinned group with an icon
					options = { toggle_hidden_on_enter = true },
					items = {
						{ name = "pinned", icon = "📌", priority = 1 },
					},
				},
			},
		})

		-- Keymaps
		vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>", {
			desc = "Next buffer",
		})
		vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>", {
			desc = "Previous buffer",
		})

		-- Jump to buffer 1..9 with <leader>1..9
		for i = 1, 9 do
			vim.keymap.set("n", "<leader>" .. i, string.format(":buffer %d<CR>", i), { desc = "Go to buffer " .. i })
		end

		-- Close current buffer safely (don't quit Neovim if it's the last buffer)
		vim.keymap.set("n", "<leader>c", function()
			local bufnr = vim.api.nvim_get_current_buf()
			-- try to switch to previous buffer; if none, create a new empty buffer
			if vim.fn.bufnr('#') ~= -1 and vim.api.nvim_buf_is_valid(vim.fn.bufnr('#')) then
				vim.cmd('buffer #')
			else
				vim.cmd('enew')
			end
			-- delete the original buffer (will prompt if modified)
			pcall(vim.cmd, 'bdelete ' .. bufnr)
		end, { desc = "Close buffer" })
		-- Close other buffers (close left and right via bufferline commands)
		vim.keymap.set("n", "<leader>co", ":BufferLineCloseLeft<CR>:BufferLineCloseRight<CR>", { desc = "Close other buffers" })

		-- Pin / unpin buffer
		vim.keymap.set("n", "<leader>p", ":BufferLineTogglePin<CR>", { desc = "Toggle pin for buffer" })
	end,
}
