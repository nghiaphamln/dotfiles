return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    -- use nvim-notify as backend for messages
    vim.notify = require("notify")
    require("notify").setup({
      stages = "fade",
      timeout = 3000,
      render = "compact",
    })

    require("noice").setup({
      cmdline = { enabled = true, view = "cmdline" },
      messages = { enabled = true, view_search = "mini" },
      presets = {
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
      routes = {
        -- keep notifications visible as compact notify popups
        { view = "notify", filter = { event = "msg_show" } },
      },
    })

    -- some convenient mappings
    vim.keymap.set("n", "<leader>nl", function() require("noice").lsp_message() end, { desc = "Noice: last LSP message" })
    vim.keymap.set("n", "<leader>nh", function() vim.cmd("Noice history") end, { desc = "Noice: message history" })
    vim.keymap.set("n", "<leader>nd", function() vim.cmd("Noice dismiss") end, { desc = "Noice: dismiss" })
  end,
}
