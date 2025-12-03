-- Basic Keymaps
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Save
map("n", "<C-s>", "<Cmd>w<CR>", opts)

-- Navigation between windows
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Buffer navigation
map("n", "<S-h>", "<Cmd>bprevious<CR>", opts)
map("n", "<S-l>", "<Cmd>bnext<CR>", opts)

-- Split windows
map("n", "<leader>|", "<Cmd>vsplit<CR>", opts)
map("n", "<leader>-", "<Cmd>split<CR>", opts)

-- Better up/down movement
map("n", "j", "gj", opts)
map("n", "k", "gk", opts)

-- Search highlight clear
map("n", "<Esc>", "<Cmd>nohl<CR>", opts)

-- Diagnostics (LSP)
map("n", "[d", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
map("n", "]d", "<Cmd>lua vim.diagnostic.goto_next()<CR>", opts)
map("n", "<leader>d", "<Cmd>lua vim.diagnostic.open_float()<CR>", opts)

-- File Explorer
map("n", "<leader>e", "<Cmd>Neotree toggle<CR>", opts)

-- Format
map("n", "<leader>fm", "<Cmd>lua require('conform').format({ async = true })<CR>", opts)

-- Comment (handled by Comment.nvim plugin)
-- gcc - toggle line comment
-- gbc - toggle block comment

-- Terminal
map("n", "<C-\\>", "<Cmd>ToggleTerm<CR>", opts)
