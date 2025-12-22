-- Formatting and Linting

return {
	-- Conform: Code formatter
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		keys = {
			{
				"<leader>fc",
				function()
					require("conform").format({ async = true })
				end,
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black", "isort" },
				rust = { "rustfmt" },
				go = { "gofmt" },
				javascript = { "prettier" },
				json = { "prettier" },
				markdown = { "prettier" },
				yaml = { "prettier" },
			},
		},
	},

	-- Nvim-lint: Linting
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				python = { "pylint" },
				rust = { "clippy" },
				lua = { "selene" },
				go = { "golangci-lint" },
			}

			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}
