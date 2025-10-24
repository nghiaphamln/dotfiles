return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
	config = function()
		-- Setup capabilities for all servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
		if cmp_nvim_lsp_ok then
			capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
		end

		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls", "clangd", "rust_analyzer" },
			handlers = {
				-- LuaLS configuration with custom settings
				lua_ls = function()
					require("lspconfig").lua_ls.setup {
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
								workspace = {
									library = vim.api.nvim_get_runtime_file("", true),
								},
							},
						},
					}
				end,
				
				-- Clangd configuration
				clangd = function()
					require("lspconfig").clangd.setup {
						capabilities = capabilities,
					}
				end,
				
				-- Rust Analyzer configuration
				rust_analyzer = function()
					require("lspconfig").rust_analyzer.setup {
						capabilities = capabilities,
						settings = {
							["rust-analyzer"] = {
								check = {
									command = "clippy",
								},
							},
						},
					}
				end,
				
				-- Default handler for any other servers
				function(server_name)
					require("lspconfig")[server_name].setup {
						capabilities = capabilities,
					}
				end,
			},
		})
	end,
}
