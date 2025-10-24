local M = {}

function M.setup()
  -- Add any autocommands here
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
    desc = "Highlight yanked text",
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  })
  
  -- Setup project detection autocommands
  require("projects").setup_autocmds()
end

return M