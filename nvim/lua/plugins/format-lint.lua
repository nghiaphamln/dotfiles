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
			formatters = {
				black = {
					command = function(self, ctx)
						return require("config.python").resolve_tool("black", self.cwd(self, ctx))
					end,
				},
				isort = {
					command = function(self, ctx)
						return require("config.python").resolve_tool("isort", self.cwd(self, ctx))
					end,
				},
			},
			formatters_by_ft = {
				cs = { "csharpier" },
				lua = { "stylua" },
				python = { "black", "isort" },
				rust = { "rustfmt" },
				go = { "gofmt" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				cmake = { "cmake_format" },
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
			local python = require("config.python")
			local lint = require("lint")
			lint.linters.pylint = vim.tbl_deep_extend("force", lint.linters.pylint or {}, {
				cmd = function()
					local bufname = vim.api.nvim_buf_get_name(0)
					local root = vim.fs.root(bufname, python.root_markers)
					return python.resolve_tool("pylint", root)
				end,
			})
			lint.linters_by_ft = {
				python = { "pylint" },
				rust = { "clippy" },
				lua = { "selene" },
				go = { "golangci-lint" },
				c = { "cppcheck" },
				cpp = { "cppcheck" },
			}

			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}
