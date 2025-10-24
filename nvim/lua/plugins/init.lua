require("lazy").setup({
  { import = "plugins.ui" },
  { import = "plugins.editing" },
  { import = "plugins.lsp" },
  { import = "plugins.completion" },
  { import = "plugins.treesitter" },
  { import = "plugins.git" },
  { import = "plugins.debug" },
  { import = "plugins.formatting" },
}, {
  checker = {
    enabled = true,
    notify = false
  },
  change_detection = {
    notify = false
  },
  rocks = {
    enabled = false
  }
})