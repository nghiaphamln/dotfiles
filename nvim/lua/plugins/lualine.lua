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
			globalstatus = false,
			refresh = {
				statusline = 1000,
				tabline = 1000,
				winbar = 1000,
			},
		},
		sections = {
			lualine_a = {
				"mode",
				{
					function()
						local clients = vim.lsp.get_clients({ bufnr = 0 })
						if next(clients) then
							local client_names = {}
							for _, client in pairs(clients) do
								table.insert(client_names, client.name)
							end
							return "[" .. table.concat(client_names, ",") .. "]"
						end
						return ""
					end,
					cond = function()
						return next(vim.lsp.get_clients({ bufnr = 0 })) ~= nil
					end,
				},
			},
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = {
				{
					"filename",
					path = 1,
				},
				function()
					return require("lsp-progress").progress()
				end,
			},
			lualine_x = {
				"encoding",
				"fileformat",
				"filetype",
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
