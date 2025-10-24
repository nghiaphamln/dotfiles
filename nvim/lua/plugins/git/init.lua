return {
  -- Git interface
  {
    "NeogitOrg/neogit",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {},
  },
  
  -- GitHub Copilot
  {
    "github/copilot.vim",
    event = "VeryLazy",
  },
}