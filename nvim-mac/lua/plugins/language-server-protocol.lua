return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"seblyng/roslyn.nvim",
	},
	config = function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
		if ok_cmp and cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities then
			capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
		end

		local servers = {
			lua_ls = {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
					},
				},
			},

			clangd = {},

			rust_analyzer = {
				settings = {
					["rust-analyzer"] = {
						cargo = { loadOutDirsFromCheck = true },
						procMacro = { enable = true },
						check = { command = "clippy" },
						diagnostics = { experimental = { enable = true } },
						assist = { emitMustUse = true },
					},
				},
			},

			pyright = {
                cmd = { "pyright-langserver", "--stdio" },
                filetypes = { "python" },
                root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
                capabilities = capabilities,
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "basic",
							diagnosticMode = "workspace",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							include = { "*" },
							exclude = { "**/node_modules", "**/__pycache__", ".venv", "venv" },
							reportMissingTypeStubs = false,
							reportOptionalMemberAccess = false,
							reportOptionalOperand = false,
							reportOptionalSubscript = false,
							reportOptionalCall = false,
							reportUnknownParameterType = false,
							reportUnknownArgumentType = false,
							reportUnknownVariableType = false,
							reportUnknownMemberType = false,
							reportUnknownFunctionMemberType = false,
						},
					},
				},
			},
		}

		vim.diagnostic.config({
			virtual_text = true,
			signs = {},
			underline = true,
			update_in_insert = true,
			severity_sort = true,
			float = {
				border = "rounded",
				source = "if_many",
			},
		})

		for server_name, server_config in pairs(servers) do
			server_config.capabilities = capabilities
			local ok, err = pcall(function()
				vim.lsp.config(server_name, server_config)
			end)
			if not ok then
				vim.notify("LSP setup skipped for '" .. server_name .. "': " .. tostring(err), vim.log.levels.DEBUG)
			end
		end

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to definition" })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "LSP: Go to implementation" })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "LSP: Show references" })
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover documentation" })
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP: Rename symbol" })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code action" })
		vim.keymap.set("n", "<leader>fd", vim.diagnostic.open_float, { desc = "LSP: Show diagnostics" })

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if not client then
					return
				end
				local bufnr = args.buf

				if client.name == "roslyn" then
					return
				end

				local function bufmap(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
				end

				if client.server_capabilities.definitionProvider then
					bufmap("n", "gd", vim.lsp.buf.definition, "LSP: Go to definition")
				end
				if client.server_capabilities.declarationProvider then
					bufmap("n", "gD", vim.lsp.buf.declaration, "LSP: Go to declaration")
				end
				if client.server_capabilities.implementationProvider then
					bufmap("n", "gI", vim.lsp.buf.implementation, "LSP: Go to implementation")
				end
				if client.server_capabilities.referencesProvider then
					bufmap("n", "gr", vim.lsp.buf.references, "LSP: Show references")
				end
				if client.server_capabilities.renameProvider then
					bufmap("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename symbol")
				end
				if client.server_capabilities.codeActionProvider then
					bufmap({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, "LSP: Code action")
				end
				if client.server_capabilities.documentFormattingProvider then
					bufmap("n", "<leader>f", function()
						vim.lsp.buf.format({ async = true })
					end, "LSP: Format buffer")
				end
			end,
		})
	end,
}
