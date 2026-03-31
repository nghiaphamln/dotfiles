-- Diagnostic display configuration
vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		spacing = 4,
		source = "if_many",
		format = function(diagnostic)
			local severity = diagnostic.severity
			local severity_str = ({
				[vim.diagnostic.severity.ERROR] = "E",
				[vim.diagnostic.severity.WARN] = "W",
				[vim.diagnostic.severity.INFO] = "I",
				[vim.diagnostic.severity.HINT] = "H",
			})[severity] or "?"

			return string.format("[%s] %s", severity_str, diagnostic.message)
		end,
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})
