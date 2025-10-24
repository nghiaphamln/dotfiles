return {
  -- Mason (package manager for LSP servers, DAP, linters, etc.)
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonUpdate" },
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      },
      registries = {"github:mason-org/mason-registry", "github:Crashdummyy/mason-registry"},
    },
  },
  
  -- Mason LSP Config
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = { "lua_ls", "clangd" },
      automatic_installation = true,
    },
    dependencies = { "mason.nvim" },
  },
}