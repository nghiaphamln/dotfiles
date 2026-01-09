return {
	"okuuva/auto-save.nvim",
	cmd = "ASToggle",
	event = { "InsertLeave", "TextChanged" },
	opts = {
		enabled = true,
		trigger_events = {
			immediate_save = { "BufLeave", "FocusLost", "QuitPre", "VimSuspend" },
			defer_save = { "InsertLeave", "TextChanged" },
			cancel_deferred_save = { "InsertEnter" },
		},
		condition = function(buf)
			local filter = {
				filetype = {
					"NvimTree",
					"neo-tree",
					"TelescopePrompt",
					"alpha",
					"dashboard",
					"lazygit",
					"oil",
					"toggleterm",
					"prompt",
					"gitcommit",
				},
				buftype = {
					"terminal",
					"nofile",
					"prompt",
				},
			}

			local function check(patterns)
				if not patterns then
					return false
				end
				for _, pattern in ipairs(patterns) do
					if pattern == vim.api.nvim_buf_get_option(buf, "filetype") then
						return true
					end
					if pattern == vim.api.nvim_buf_get_option(buf, "buftype") then
						return true
					end
				end
				return false
			end

			if check(filter.filetype) or check(filter.buftype) then
				return false
			end
			return true
		end,
		write_all_buffers = false,
		noautocmd = false,
		lockmarks = false,
		debounce_delay = 1000,
		debug = false,
	},
}
