-- Git plugins: inline decorations and git client
return {
	-- Gitsigns: Git decorations inline
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 300,
				ignore_whitespace = true,
			},
			current_line_blame_formatter = " <author>, <author_time:%Y-%m-%d> · <summary>",
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns
				local map = function(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end

				-- Navigation
				map("n", "]h", function() gs.nav_hunk("next") end, "Next Hunk")
				map("n", "[h", function() gs.nav_hunk("prev") end, "Prev Hunk")

				-- Actions
				map("n", "<leader>gs", gs.stage_hunk, "Stage Hunk")
				map("n", "<leader>gr", gs.reset_hunk, "Reset Hunk")
				map("v", "<leader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage Hunk")
				map("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset Hunk")
				map("n", "<leader>gS", gs.stage_buffer, "Stage Buffer")
				map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
				map("n", "<leader>gp", gs.preview_hunk_inline, "Preview Hunk Inline")
				map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame Line")
				map("n", "<leader>gd", gs.diffthis, "Diff This")
			end,
		},
	},

	-- LazyGit: Git client
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = "LazyGit",
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
		dependencies = { "nvim-lua/plenary.nvim" },
	},
}
