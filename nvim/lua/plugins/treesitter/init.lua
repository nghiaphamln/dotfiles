return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "lua", "cpp", "rust" }, -- Added rust since we have rust debugging
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
      autotag = {
        enable = true,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      require("nvim-treesitter.install").prefer_git = true
      require("nvim-treesitter.install").compilers = { "g++", "gcc" }
    end,
  },
}