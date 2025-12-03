return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    terminal = {
      win = {
        keys = {
          nav_h = { "<C-h>", function(self) return self:is_floating() and "<c-h>" or vim.schedule(function() vim.cmd.wincmd("h") end) end, desc = "Go to Left Window", expr = true, mode = "t" },
          nav_j = { "<C-j>", function(self) return self:is_floating() and "<c-j>" or vim.schedule(function() vim.cmd.wincmd("j") end) end, desc = "Go to Lower Window", expr = true, mode = "t" },
          nav_k = { "<C-k>", function(self) return self:is_floating() and "<c-k>" or vim.schedule(function() vim.cmd.wincmd("k") end) end, desc = "Go to Upper Window", expr = true, mode = "t" },
          nav_l = { "<C-l>", function(self) return self:is_floating() and "<c-l>" or vim.schedule(function() vim.cmd.wincmd("l") end) end, desc = "Go to Right Window", expr = true, mode = "t" },
        },
      },
    },
  },
  keys = {
    { "<leader>.", function() require("snacks").scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S", function() require("snacks").scratch.select() end, desc = "Select Scratch Buffer" },
  },
}
