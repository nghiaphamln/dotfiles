local M = {}

local function map(mode, lhs, rhs, opts)
  local options = {
    noremap = true,
    silent = true,
  }
  if opts then
    for k, v in pairs(opts) do
      options[k] = v
    end
  end

  vim.keymap.set(mode, lhs, rhs, options)
end

function M.setup()
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "

  -- Window navigation
  map("n", "<C-h>", "<C-w>h")
  map("n", "<C-j>", "<C-w>j")
  map("n", "<C-k>", "<C-w>k")
  map("n", "<C-l>", "<C-w>l")

  -- Resize windows
  map("n", "<C-Up>", ":resize -2<CR>")
  map("n", "<C-Down>", ":resize +2<CR>")
  map("n", "<C-Left>", ":vertical resize -2<CR>")
  map("n", "<C-Right>", ":vertical resize +2<CR>")

  -- Move text in visual mode
  map("v", "<A-j>", ":m .+1<CR>==")
  map("v", "<A-k>", ":m .-2<CR>==")

  -- Keep text selected when indenting
  map("v", "<", "<gv")
  map("v", ">", ">gv")

  -- Clear search highlights
  map("n", "<Esc>", ":noh<CR>")

  -- Save file
  map("n", "<C-s>", ":w<CR>")

  -- Split windows
  map("n", "<leader>sv", ":vsplit<CR>", {
    desc = "Split vertical",
  })
  map("n", "<leader>sh", ":split<CR>", {
    desc = "Split horizontal",
  })

  -- Quit
  map("n", "<leader>q", ":q<CR>")
  map("n", "<leader>Q", ":qa!<CR>")

  map("n", "<leader>ne", function()
    vim.diagnostic.goto_next()
  end, {
    desc = "Next diagnostic",
  })
  map("n", "<leader>pe", function()
    vim.diagnostic.goto_prev()
  end, {
    desc = "Previous diagnostic",
  })

  -- Esc key to exit neotree and return to edit window
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "neo-tree",
    callback = function()
      vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", ":wincmd p<CR>", {
        noremap = true,
        silent = true,
      })
    end,
  })
end

return M