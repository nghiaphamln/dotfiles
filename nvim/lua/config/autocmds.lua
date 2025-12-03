-- Auto Commands
local function augroup(name)
  return vim.api.nvim_create_augroup("config_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Auto-create missing undo directory
local undo_dir = os.getenv("HOME") .. "/.config/nvim/undo"
if vim.fn.isdirectory(undo_dir) == 0 then
  vim.fn.mkdir(undo_dir, "p")
end
