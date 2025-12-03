local M = {}

local function map(mode, lhs, rhs, opts)
	local options = {
		noremap = true,
		silent = true,
	}
	if opts then
		for k, v in pairs(opts) do
			options[k] = v
		end
	end

	vim.keymap.set(mode, lhs, rhs, options)
end

function M.setup()
	vim.g.mapleader = " "

	map("n", "x", '"_x')
	map("n", "<leader>d", '"_dd')

	-- Move between windows
	map("n", "<C-h>", "<C-w>h")
	map("n", "<C-j>", "<C-w>j")
	map("n", "<C-k>", "<C-w>k")
	map("n", "<C-l>", "<C-w>l")

	-- Resize windows
	map("n", "<C-S-k>", ":resize -2<CR>")
	map("n", "<C-S-j>", ":resize +2<CR>")
	map("n", "<C-S-h>", ":vertical resize -2<CR>")
	map("n", "<C-S-l>", ":vertical resize +2<CR>")

	-- Stay in indent mode
	map("v", "<", "<gv")
	map("v", ">", ">gv")

	-- Clear search highlight
	map("n", "<Esc>", ":noh<CR>")

	-- Split windows
	map("n", "<leader>sv", ":vsplit<CR>", { desc = "Split vertical" })
	map("n", "<leader>sh", ":split<CR>", { desc = "Split horizontal" })
end

return M
