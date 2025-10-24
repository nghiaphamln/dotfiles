local M = {}
function M.setup()
	local options = {
		number = true,
		relativenumber = true,
		mouse = "a",
		ignorecase = true,
		smartcase = true,
		hlsearch = false,
		wrap = true,
		breakindent = true,
		tabstop = 4,
		shiftwidth = 4,
		expandtab = true,
		termguicolors = true,
		cursorline = true,
		scrolloff = 8,
		sidescrolloff = 8,
		signcolumn = "yes",
		splitbelow = true,
		splitright = true,
		timeoutlen = 300,
		updatetime = 300,
		completeopt = { "menuone", "noselect" },
		clipboard = "unnamedplus",
	}

	for k, v in pairs(options) do
		vim.opt[k] = v
	end

	vim.opt.shortmess:append("c")
	vim.opt.whichwrap:append("<,>,[,],h,l")
	
	-- WSL2 clipboard integration - detect and configure automatically
	local is_wsl = vim.fn.executable('wslpath') == 1
	
	if is_wsl then
		-- Check for win32yank first (preferred method)
		if vim.fn.executable('win32yank.exe') == 1 then
			vim.g.clipboard = {
				name = 'WslWin32yank',
				copy = {
					['+'] = 'win32yank.exe -i --crlf',
					['*'] = 'win32yank.exe -i --crlf',
				},
				paste = {
					['+'] = 'win32yank.exe -o --lf',
					['*'] = 'win32yank.exe -o --lf',
				},
			}
		-- Fallback to Windows clipboard utilities
		elseif vim.fn.executable('clip.exe') == 1 then
			vim.g.clipboard = {
				name = 'WslClipboard',
				copy = {
					['+'] = 'clip.exe',
					['*'] = 'clip.exe',
				},
				paste = {
					['+'] = {'powershell.exe', '-c', 'Get-Clipboard'},
					['*'] = {'powershell.exe', '-c', 'Get-Clipboard'},
				},
			}
		end
	end
end

return M
