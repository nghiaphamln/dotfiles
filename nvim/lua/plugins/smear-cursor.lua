return {
	"sphamba/smear-cursor.nvim",
	event = "VeryLazy",
	opts = {
		smear_between_buffers = true,
		smear_between_neighbor_lines = true,
		scroll_buffer_space = true,
		smear_insert_mode = true,
		legacy_computing_symbols_support = false,
		cursor_color = "#bdae93",
		stiffness = 0.78,
		trailing_stiffness = 0.62,
		stiffness_insert_mode = 0.72,
		trailing_stiffness_insert_mode = 0.7,
		damping = 0.93,
		damping_insert_mode = 0.9,
	},
}
