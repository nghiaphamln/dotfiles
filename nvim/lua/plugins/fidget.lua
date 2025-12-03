return {
  "j-hui/fidget.nvim",
  event = "LspAttach",
  opts = {
    progress = {
      poll_rate = 0,
      suppress_on_insert = true,
    },
  },
}
