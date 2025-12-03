return {
  "j-hui/fidget.nvim",
  event = "LspAttach",
  config = function()
    require("fidget").setup({
      text = {
        spinner = "dots",
      },
      timer = {
        spinner_rate = 125,
        fidget_decay = 2000,
        task_decay = 500,
      },
      window = {
        border = "none",
      },
    })
  end,
}
