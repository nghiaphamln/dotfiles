return {
	"github/copilot.vim",
	config = function()
		-- Prevent Copilot from mapping Tab (we use super-tab preset in blink)
		vim.g.copilot_no_tab_map = true

		-- Map Enter to accept Copilot suggestion
		vim.keymap.set("i", "<C-CR>", 'copilot#Accept("\\<CR>")', {
			expr = true,
			replace_keycodes = false,
			noremap = true,
		})
	end,
}
