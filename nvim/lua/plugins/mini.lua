return {
  -- Auto pairs - smarter than nvim-autopairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_ts = { "string" },
      skip_unbalanced = true,
      markdown = true,
    },
  },

  -- Smart comments with treesitter
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
