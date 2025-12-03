return {
  "olimorris/codecompanion.nvim",
  opts = {
    adapters = {
      acp = {
        qwen = function()
          return require("codecompanion.adapters").extend("gemini_cli", {
            name = "qwen",
            formatted_name = "Qwen",
            commands = {
              default = { "qwen", "--experimental-acp" },
              yolo = { "qwen", "--yolo", "--experimental-acp" },
            },
            defaults = {
              auth_method = "qwen-oauth",
              mcpServers = {},
              timeout = 200000,
            },
          })
        end,
      },
    },
    strategies = {
      chat = {
        adapter = "qwen",
      },
    },
  },
  keys = {
    { "<leader>ccc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Code Companion Chat" },
    { "<leader>cca", "<cmd>CodeCompanionChat Add<cr>", mode = { "v" }, desc = "Code Companion Add Selection" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}

