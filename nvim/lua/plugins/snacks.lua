return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		input = { enabled = true },
		notifier = { enabled = true },
		picker = {
			enabled = true,
			ui_select = true,
			sources = {
				files = {
					hidden = true,
					ignored = false,
				},
			},
		},
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = true },
		terminal = {
			win = {
				keys = {
					nav_h = {
						"<C-h>",
						function(self)
							return self:is_floating() and "<c-h>"
								or vim.schedule(function()
									vim.cmd.wincmd("h")
								end)
						end,
						desc = "Go to Left Window",
						expr = true,
						mode = "t",
					},
					nav_j = {
						"<C-j>",
						function(self)
							return self:is_floating() and "<c-j>"
								or vim.schedule(function()
									vim.cmd.wincmd("j")
								end)
						end,
						desc = "Go to Lower Window",
						expr = true,
						mode = "t",
					},
					nav_k = {
						"<C-k>",
						function(self)
							return self:is_floating() and "<c-k>"
								or vim.schedule(function()
									vim.cmd.wincmd("k")
								end)
						end,
						desc = "Go to Upper Window",
						expr = true,
						mode = "t",
					},
					nav_l = {
						"<C-l>",
						function(self)
							return self:is_floating() and "<c-l>"
								or vim.schedule(function()
									vim.cmd.wincmd("l")
								end)
						end,
						desc = "Go to Right Window",
						expr = true,
						mode = "t",
					},
				},
			},
		},
		words = { enabled = true },
	},
	config = function(_, opts)
		local snacks = require("snacks")
		snacks.setup(opts)
		snacks.input.enable()
		snacks.picker.setup()
	end,
	keys = {
		-- Scratch buffers
		{ "<leader>.", function() require("snacks").scratch() end, desc = "Toggle Scratch Buffer" },
		{ "<leader>S", function() require("snacks").scratch.select() end, desc = "Select Scratch Buffer" },
		-- File finding
		{ "<leader>ff", function() require("snacks").picker.files() end, desc = "Find Files" },
		{ "<leader>fw", function() require("snacks").picker.grep() end, desc = "Find Word" },
		{ "<leader><leader>", function() require("snacks").picker.recent() end, desc = "Recent Files" },
		{ "<leader>fb", function() require("snacks").picker.buffers() end, desc = "Buffers" },
		{ "<leader>fh", function() require("snacks").picker.help() end, desc = "Help Tags" },
		-- TODO search
		{
			"<leader>ft",
			function()
				require("snacks").picker.grep({
					search = "TODO|FIXME|HACK|NOTE|PERF|WARNING",
					regex = true,
					title = "TODOs",
				})
			end,
			desc = "Find TODOs",
		},
	},
}
