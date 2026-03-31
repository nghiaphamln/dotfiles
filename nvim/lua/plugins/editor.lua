return {
	-- Treesitter: Parser management (highlight/indent handled by Neovim 0.12 built-in)
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter").setup()
			require("nvim-treesitter.install").install({
				"lua", "vim", "vimdoc", "bash",
				"markdown", "markdown_inline",
				"python", "rust", "go",
				"json", "yaml", "c", "cpp", "cmake",
				"css", "html", "javascript",
				"latex", "regex", "scss", "svelte", "tsx", "typst", "vue",
			})
		end,
	},

	-- Treesitter Context: Show function/class context
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},

	-- Rainbow delimiters: Colorize nested brackets
	{
		"hiphish/rainbow-delimiters.nvim",
		event = "VeryLazy",
	},

	-- Indent blankline: Show indentation guides
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "VeryLazy",
		main = "ibl",
		opts = {
			indent = {
				char = "┊",
			},
		},
	},

	-- Illuminate: Highlight word under cursor
	{
		"RRethy/vim-illuminate",
		event = "VeryLazy",
		config = function()
			require("illuminate").configure({
				delay = 200,
				under_cursor = true,
			})
		end,
	},

	-- Which-key: Show keybinding hints
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			preset = "helix",
			icons = {
				rules = false,
			},
		},
	},

	-- Todo Comments: Highlight TODO/FIXME/HACK/NOTE
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo" },
			{ "[t", function() require("todo-comments").jump_prev() end, desc = "Prev Todo" },
		},
		opts = {},
	},

	-- Symbol Usage: Highlight symbol usage in the buffer
	{
		"Wansmer/symbol-usage.nvim",
		event = "LspAttach",
		config = function()
			require("symbol-usage").setup({
				request_pending_text = false,
				text_format = function(symbol)
					local res = {}
					local round_start = { "", "SymbolUsageRounding" }
					local round_end = { "", "SymbolUsageRounding" }

					if symbol.references and symbol.references > 0 then
						table.insert(res, round_start)
						table.insert(res, { "󰌹 " .. symbol.references, "SymbolUsageRef" })
						table.insert(res, round_end)
					end

					if symbol.definition and symbol.definition > 0 then
						if #res > 0 then table.insert(res, { " ", "NonText" }) end
						table.insert(res, round_start)
						table.insert(res, { "󰳽 " .. symbol.definition, "SymbolUsageDef" })
						table.insert(res, round_end)
					end

					if symbol.implementation and symbol.implementation > 0 then
						if #res > 0 then table.insert(res, { " ", "NonText" }) end
						table.insert(res, round_start)
						table.insert(res, { "󰡱 " .. symbol.implementation, "SymbolUsageImpl" })
						table.insert(res, round_end)
					end

					return res
				end,
			})

			-- Auto-refresh sau khi LSP attach để tránh stuck loading khi gopls index xong
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("SymbolUsageRefresh", { clear = true }),
				callback = function()
					vim.defer_fn(function()
						require("symbol-usage").refresh()
					end, 2000)
				end,
			})
		end,
	},
}
