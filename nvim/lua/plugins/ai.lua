-- AI Plugin Configuration: Copilot and related AI tools

return {
	-- Copilot
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "BufReadPost",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_during_completion = false,
				keymap = {
					accept = "<C-a>", -- Accept suggestion with Ctrl+a
					next = "<C-n>", -- Next suggestion with Ctrl+n
					prev = "<C-p>", -- Previous suggestion with Ctrl+p
					dismiss = "<C-]>",
				},
			},
			panel = { enabled = false },
			filetypes = {
				markdown = true,
				help = true,
			},
		},
	},

	-- Copilot Chat
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		cmd = "CopilotChat",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim" },
		},
		opts = function()
			local user = vim.env.USER or "User"
			user = user:sub(1, 1):upper() .. user:sub(2)
			return {
				auto_insert_mode = true,
				debug = false,
				headers = {
					user = "  " .. user .. " ",
					assistant = "  Copilot ",
				},
				window = {
					layout = "vertical",
					width = 0.4,
					border = "rounded",
				},
			}
		end,
		keys = {
			{ "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
			-- Toggle chat
			{
				"<leader>cc",
				function()
					return require("CopilotChat").toggle()
				end,
				desc = "Toggle Chat",
				mode = { "n", "v" },
			},
			-- Clear/reset chat
			{
				"<leader>cx",
				function()
					return require("CopilotChat").reset()
				end,
				desc = "Clear Chat",
				mode = { "n", "v" },
			},
			-- Quick chat (input prompt)
			{
				"<leader>cq",
				function()
					vim.ui.input({ prompt = "Quick Chat: " }, function(input)
						if input ~= nil and input ~= "" then
							require("CopilotChat").ask(input)
						end
					end)
				end,
				desc = "Quick Chat",
				mode = { "n", "v" },
			},
			-- Prompt actions
			{
				"<leader>cp",
				function()
					local actions = require("CopilotChat.actions")
					require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
				end,
				desc = "Prompt Actions",
				mode = { "n", "v" },
			},
			-- Add current buffer to chat
			{
				"<leader>cb",
				function()
					local chat = require("CopilotChat")
					chat.ask("", { selection = require("CopilotChat.select").buffer })
				end,
				desc = "Add Buffer to Chat",
			},
			-- Quick actions (keep your familiar keymaps)
			{ "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "Explain Code", mode = { "n", "v" } },
			{ "<leader>cr", "<cmd>CopilotChatReview<cr>", desc = "Review Code", mode = { "n", "v" } },
			{ "<leader>cf", "<cmd>CopilotChatFix<cr>", desc = "Fix Bug", mode = { "n", "v" } },
			{ "<leader>co", "<cmd>CopilotChatOptimize<cr>", desc = "Optimize Code", mode = { "n", "v" } },
		},
		config = function(_, opts)
			local chat = require("CopilotChat")

			-- Auto config for chat buffer
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-chat",
				callback = function()
					vim.opt_local.relativenumber = false
					vim.opt_local.number = false
				end,
			})

			chat.setup(opts)
		end,
	},

	-- copilot-language-server (ensure it's disabled since copilot.lua has its own)
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- copilot.lua only works with its own copilot lsp server
				copilot = { enabled = false },
			},
		},
	},

	-- add ai_accept action for copilot (adapted from LazyVim)
	{
		"zbirenbaum/copilot.lua",
		opts = function()
			-- Create a helper function to accept copilot suggestions
			if not vim.g.copilot_ai_accept then
				vim.g.copilot_ai_accept = function()
					if package.loaded["copilot.suggestion"] and require("copilot.suggestion").is_visible() then
						-- Create undo point before accepting suggestion
						vim.cmd("undojoin")
						require("copilot.suggestion").accept()
						return true
					end
				end
			end
		end,
	},

	-- Add lualine status integration for Copilot (simplified)
	{
		"nvim-lualine/lualine.nvim",
		optional = true,
		event = "VeryLazy",
		opts = function(_, opts)
			local function copilot_status()
				local clients = package.loaded["copilot"] and vim.lsp.get_clients({ name = "copilot", bufnr = 0 }) or {}
				if #clients > 0 then
					local status = require("copilot.status").data.status
					if status == "InProgress" then
						return "  Active"
					elseif status == "Warning" then
						return "  Warning"
					else
						return "  Ready"
					end
				end
				return "  Off"
			end

			opts.sections = opts.sections or {}
			opts.sections.lualine_x = opts.sections.lualine_x or {}

			-- Add copilot status to the left of the existing components
			table.insert(opts.sections.lualine_x, 1, {
				copilot_status,
				cond = function()
					return package.loaded["copilot"] ~= nil
				end,
			})
		end,
	},

	-- Copilot CMP source integration (for completion)
	{
		"saghen/blink.cmp",
		optional = true,
		dependencies = { "fang2hou/blink-copilot" },
		opts = {
			sources = {
				default = { "copilot" },
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						score_offset = 100,
						async = true,
					},
				},
			},
		},
	},
}
