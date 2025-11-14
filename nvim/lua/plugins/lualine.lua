return {
	"nvim-lualine/lualine.nvim",
	opts = {
			options = {
			icons_enabled = true,
			theme = "auto",
			component_separators = {
				left = "",
				right = "",
			},
			section_separators = {
				left = "",
				right = "",
			},
			disabled_filetypes = {
				statusline = {},
				winbar = {},
			},
			ignore_focus = {},
				always_last_session = true,
				-- use a single global statusline (saves vertical space and looks cleaner)
				globalstatus = true,
			refresh = {
				statusline = 1000,
				tabline = 1000,
				winbar = 1000,
			},
		},
		sections = {
			lualine_a = {
				"mode",
				-- Show only the primary LSP client to avoid long lists
				{
					function()
						local clients = vim.lsp.get_clients({ bufnr = 0 })
						if next(clients) then
							-- prefer a short identifier (first client)
							local first = clients[1]
							if first and first.name then
								return "[" .. first.name .. "]"
							end
						end
						return ""
					end,
					cond = function()
						return next(vim.lsp.get_clients({ bufnr = 0 })) ~= nil
					end,
				},
			},
			lualine_b = { "branch", "diff", "diagnostics" },
			-- Keep the center compact: truncated filename only
			lualine_c = {
				{
					-- custom truncating filename to avoid long path consuming the bar
					function()
						local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':~:')
						if name == '' then
							return '[No Name]'
						end
						local maxlen = 40
						if #name > maxlen then
							return '...' .. name:sub(- (maxlen - 3))
						end
						return name
					end,
					padding = { left = 1, right = 1 },
				},
			},
			lualine_x = {
				"encoding",
				"fileformat",
				"filetype",
				-- lsp progress moved to fidget.nvim (floating widget). Keep statusline compact.
			},
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { {
				"filename",
				path = 1,
			} },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
 		winbar = {},
 		extensions = {},
	},
}
