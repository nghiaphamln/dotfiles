-- LSP Configuration for Rust, Go, Python, Lua

return {
	-- Mason: package manager for LSP servers, formatters, linters
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {
			registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
			},
		},
	},

	-- Mason Tool Installer: automatically install formatters and linters
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
			opts = {
				ensure_installed = {
					"lua-language-server",
					"rust-analyzer",
					"gopls",
					"pyright",
					"yaml-language-server",
					"clangd",
					"roslyn",
					"stylua",
					"csharpier",
					"clang-format",
					"cppcheck",
				},
			},
		},

	-- Mason LSPConfig: bridge between Mason and Neovim LSP configs
	{
		"mason-org/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
			opts = {
				ensure_installed = {
					"lua_ls",
					"rust_analyzer",
					"gopls",
					"pyright",
					"yamlls",
					"clangd",
				},
				automatic_enable = false,
			},
	},

	-- Roslyn: C# and Razor language server integration
	{
		"seblyng/roslyn.nvim",
		ft = { "cs", "razor" },
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			filewatching = "auto",
			broad_search = true,
			lock_target = false,
			silent = false,
		},
		config = function(_, opts)
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			require("roslyn").setup(opts)
			vim.lsp.config("roslyn", {
				capabilities = vim.tbl_deep_extend("force", capabilities, {
					textDocument = {
						diagnostic = {
							dynamicRegistration = true,
						},
					},
				}),
				settings = {
					["csharp|background_analysis"] = {
						dotnet_analyzer_diagnostics_scope = "openFiles",
						dotnet_compiler_diagnostics_scope = "openFiles",
					},
					["csharp|completion"] = {
						dotnet_show_completion_items_from_unimported_namespaces = true,
						dotnet_show_name_completion_suggestions = true,
					},
					["csharp|inlay_hints"] = {
						csharp_enable_inlay_hints_for_implicit_object_creation = true,
						csharp_enable_inlay_hints_for_implicit_variable_types = true,
						csharp_enable_inlay_hints_for_types = true,
						dotnet_enable_inlay_hints_for_parameters = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
					},
					["csharp|code_lens"] = {
						dotnet_enable_references_code_lens = true,
					},
					["csharp|formatting"] = {
						dotnet_organize_imports_on_format = true,
					},
				},
			})
		end,
	},

	-- LSPConfig: configure language servers
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "mason-org/mason-lspconfig.nvim" },
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local function extend(server_name, config)
				vim.lsp.config[server_name] = vim.tbl_deep_extend("force", vim.lsp.config[server_name] or {}, config)
			end

			extend("lua_ls", {
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				root_markers = {
					".luarc.json",
					".luarc.jsonc",
					".stylua.toml",
					"stylua.toml",
					"selene.toml",
					"selene.yml",
					".git",
				},
				capabilities = capabilities,
				settings = {
					Lua = {
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
							},
						},
					},
				},
			})

			extend("rust_analyzer", {
				cmd = { "rust-analyzer" },
				filetypes = { "rust" },
				root_markers = { "Cargo.toml", "rust-project.json", ".git" },
				capabilities = capabilities,
				settings = {
					["rust-analyzer"] = {
						diagnostics = {
							enable = true,
						},
						cargo = {
							allFeatures = true,
							buildScripts = {
								enable = true,
							},
						},
						procMacro = {
							enable = true,
						},
						inlayHints = {
							enable = true,
						},
					},
				},
			})

			extend("gopls", {
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_markers = { "go.work", "go.mod", ".git" },
				capabilities = capabilities,
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
					},
				},
			})

			extend("pyright", {
				cmd = { "pyright-langserver", "--stdio" },
				filetypes = { "python" },
				root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
				capabilities = capabilities,
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "workspace",
						},
					},
				},
			})

			extend("yamlls", {
				cmd = { "yaml-language-server", "--stdio" },
				filetypes = { "yaml", "yml" },
				root_markers = { ".git" },
				capabilities = capabilities,
				settings = {
					redhat = {
						telemetry = {
							enabled = false,
						},
					},
					yaml = {
						schemas = {
							kubernetes = "/*",
							["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/latest-standalone-strict/all.json"] = "/*.k8s.yaml",
							["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
							["https://json.schemastore.org/github-action.json"] = "/action.yml",
							["https://json.schemastore.org/ansible-stable-2.9.json"] = "/*.yaml",
							["https://json.schemastore.org/pre-commit-config.json"] = "/.pre-commit-config.yaml",
							["https://json.schemastore.org/kustomization.json"] = "/kustomization.yaml",
							["https://json.schemastore.org/chart.json"] = "/Chart.yaml",
							["https://json.schemastore.org/dependabot-2.0.json"] = "/.github/dependabot.yaml",
							["https://json.schemastore.org/docker-compose.json"] = "/docker-compose*.yaml",
						},
						schemaStore = {
							enable = true,
							url = "https://www.schemastore.org/api/json/catalog.json",
						},
						format = {
							enable = true,
						},
						validate = true,
					},
				},
			})

			extend("clangd", {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders=true",
				},
				filetypes = { "c", "cpp", "objc", "objcpp" },
				root_markers = {
					".clangd",
					".clang-tidy",
					".clang-format",
					"compile_commands.json",
					"compile_flags.txt",
					".git",
				},
				capabilities = capabilities,
			})

			extend("cmake", {
				cmd = { "cmake-language-server" },
				filetypes = { "cmake" },
				root_markers = { "CMakeLists.txt", ".git" },
				capabilities = capabilities,
			})

			for _, server_name in ipairs({
				"lua_ls",
				"rust_analyzer",
				"gopls",
				"pyright",
				"yamlls",
				"clangd",
				"cmake",
			}) do
				vim.lsp.enable(server_name)
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true, noremap = true }
					local client = vim.lsp.get_client_by_id(ev.data.client_id)

					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", function()
						require("snacks").picker.lsp_implementations()
					end, opts)
					vim.keymap.set("n", "gu", function()
						require("snacks").picker.lsp_references()
					end, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					if client and vim.lsp.inlay_hint and vim.lsp.buf_is_attached(ev.buf, client.id) and client.server_capabilities.inlayHintProvider then
						vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
					end

					vim.api.nvim_create_autocmd("CursorHold", {
						buffer = ev.buf,
						callback = function()
							vim.diagnostic.open_float(nil, { focus = false })
						end,
					})

					vim.keymap.set("n", "<leader>td", "<cmd>Trouble diagnostics toggle<cr>", opts)
				end,
			})

			local wk = require("which-key")
			wk.add({
				{ "g", group = "LSP" },
				{ "gd", desc = "Go to definition" },
				{ "gD", desc = "Go to declaration" },
				{ "gi", desc = "Go to implementation" },
				{ "gu", desc = "Go to usage/references" },
				{ "K", desc = "Hover" },
				{ "<leader>rn", desc = "Rename" },
				{ "<leader>ca", desc = "Code action" },
					{ "<leader>t", group = "toggle" },
				{ "<leader>td", desc = "Toggle diagnostics (Trouble)" },
			})
		end,
	},

	-- Blink.cmp: fast completion with LSP support
	{
		"saghen/blink.cmp",
		lazy = false,
		build = "cargo build --release",
		dependencies = "rafamadriz/friendly-snippets",
		opts = {
			fuzzy = {
				implementation = "prefer_rust",
				prebuilt_binaries = {
					force_version = "latest",
				},
			},
			snippets = {
				preset = "default",
			},
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
			},
			completion = {
				accept = {
					auto_brackets = {
						enabled = true,
					},
				},
				menu = {
					draw = {
						treesitter = { "lsp" },
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			cmdline = {
				enabled = true,
				keymap = {
					preset = "cmdline",
					["<Right>"] = false,
					["<Left>"] = false,
				},
				completion = {
					list = { selection = { preselect = false } },
					menu = {
						auto_show = function()
							return vim.fn.getcmdtype() == ":"
						end,
					},
					ghost_text = { enabled = true },
				},
			},
			keymap = {
				preset = "enter",
				["<C-y>"] = { "select_and_accept" },
				["<Tab>"] = {
					function(cmp)
						if cmp.snippet_active() then
							return cmp.accept()
						end

						return cmp.select_next()
					end,
					"snippet_forward",
					"fallback",
				},
				["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
			},
		},
	},

	-- Fidget: LSP progress notifications
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		opts = {
			progress = {
				poll_rate = 0,
				suppress_on_insert = true,
			},
		},
	},

	-- Lazydev: Neovim Lua development support
	{
		"folke/lazydev.nvim",
		ft = "lua",
		cmd = "LazyDev",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	-- Diagnostic display
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
			{ "<leader>xq", "<cmd>Trouble quickfix toggle<cr>", desc = "QuickFix" },
			{ "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
		},
		opts = {},
	},
}
