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

	-- Di chuyển giữa các cửa sổ
	map("n", "<C-h>", "<C-w>h")
	map("n", "<C-j>", "<C-w>j")
	map("n", "<C-k>", "<C-w>k")
	map("n", "<C-l>", "<C-w>l")

	-- Thay đổi kích thước cửa sổ
	map("n", "<C-Up>", ":resize -2<CR>")
	map("n", "<C-Down>", ":resize +2<CR>")
	map("n", "<C-Left>", ":vertical resize -2<CR>")
	map("n", "<C-Right>", ":vertical resize +2<CR>")

	-- Di chuyển văn bản trong Visual mode
	map("v", "<A-j>", ":m .+1<CR>==")
	map("v", "<A-k>", ":m .-2<CR>==")

	-- Giữ văn bản đã chọn khi thụt lề
	map("v", "<", "<gv")
	map("v", ">", ">gv")

	-- Tắt highlight sau khi tìm kiếm
	map("n", "<Esc>", ":noh<CR>")

	-- Lưu file
	map("n", "<C-s>", ":w<CR>")

	-- Split windows
	map("n", "<leader>sv", ":vsplit<CR>", {
		desc = "Split vertical",
	})
	map("n", "<leader>sh", ":split<CR>", {
		desc = "Split horizontal",
	})

	-- (leader+1..9 mappings removed per user request)

	-- Thoát
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

	-- Phím Escape để thoát khỏi Neo-tree và quay lại chỗ edit
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "neo-tree",
		callback = function()
			vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", ":wincmd p<CR>", {
				noremap = true,
				silent = true,
			})
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "c", "cpp", "cc", "cxx" },
		callback = function()
			-- F5: Compile và chạy trong floating window
			vim.keymap.set("n", "<F5>", function()
				local file = vim.fn.expand("%:p")
				local filename = vim.fn.expand("%:t:r")
				local ext = vim.fn.expand("%:e")

				vim.cmd("w") -- Lưu file trước

				-- Tạo floating window
				local width = math.floor(vim.o.columns * 0.8)
				local height = math.floor(vim.o.lines * 0.8)
				local row = math.floor((vim.o.lines - height) / 2)
				local col = math.floor((vim.o.columns - width) / 2)

				local buf = vim.api.nvim_create_buf(false, true)
				local win = vim.api.nvim_open_win(buf, true, {
					relative = "editor",
					width = width,
					height = height,
					row = row,
					col = col,
					style = "minimal",
					border = "rounded",
					title = " C++ Compile & Run ",
					title_pos = "center",
				})

				-- Thiết lập terminal trong floating window
				local compile_cmd
				if ext == "cpp" or ext == "cc" or ext == "cxx" then
					compile_cmd = string.format('g++ -o %s.exe "%s" && %s.exe', filename, file, filename)
				else -- .c
					compile_cmd = string.format('gcc -o %s.exe "%s" && %s.exe', filename, file, filename)
				end

				vim.fn.termopen(compile_cmd, {
					on_exit = function(_, exit_code)
						if exit_code == 0 then
							print("Compile và chạy thành công!")
						else
							print("Có lỗi trong quá trình compile/chạy")
						end
					end,
				})

				vim.cmd("startinsert")

				-- Keymap để đóng floating window
				vim.keymap.set("n", "<Esc>", function()
					vim.api.nvim_win_close(win, true)
				end, { buffer = buf })

				vim.keymap.set("t", "<Esc>", function()
					vim.api.nvim_win_close(win, true)
				end, { buffer = buf })
			end, {
				buffer = true,
				desc = "Compile và chạy C/C++ (floating)",
			})

			-- F6: Chỉ compile trong floating window
			vim.keymap.set("n", "<F6>", function()
				local file = vim.fn.expand("%:p")
				local filename = vim.fn.expand("%:t:r")
				local ext = vim.fn.expand("%:e")

				vim.cmd("w")

				-- Tạo floating window nhỏ hơn cho compile
				local width = math.floor(vim.o.columns * 0.6)
				local height = math.floor(vim.o.lines * 0.4)
				local row = math.floor((vim.o.lines - height) / 2)
				local col = math.floor((vim.o.columns - width) / 2)

				local buf = vim.api.nvim_create_buf(false, true)
				local win = vim.api.nvim_open_win(buf, true, {
					relative = "editor",
					width = width,
					height = height,
					row = row,
					col = col,
					style = "minimal",
					border = "rounded",
					title = " C++ Compile ",
					title_pos = "center",
				})

				local compile_cmd
				if ext == "cpp" or ext == "cc" or ext == "cxx" then
					compile_cmd = string.format('g++ -o %s.exe "%s"', filename, file)
				else -- .c
					compile_cmd = string.format('gcc -o %s.exe "%s"', filename, file)
				end

				vim.fn.termopen(compile_cmd, {
					on_exit = function(_, exit_code)
						if exit_code == 0 then
							print("Compile thành công!")
						else
							print("Có lỗi compile")
						end
					end,
				})

				vim.cmd("startinsert")

				-- Keymap để đóng floating window
				vim.keymap.set("n", "<Esc>", function()
					vim.api.nvim_win_close(win, true)
				end, { buffer = buf })

				vim.keymap.set("t", "<Esc>", function()
					vim.api.nvim_win_close(win, true)
				end, { buffer = buf })
			end, {
				buffer = true,
				desc = "Compile C/C++ (floating)",
			})

			-- Ctrl+F5: Chạy file đã compile sẵn trong floating window
			vim.keymap.set("n", "<C-F5>", function()
				local filename = vim.fn.expand("%:t:r")

				local width = math.floor(vim.o.columns * 0.7)
				local height = math.floor(vim.o.lines * 0.6)
				local row = math.floor((vim.o.lines - height) / 2)
				local col = math.floor((vim.o.columns - width) / 2)

				local buf = vim.api.nvim_create_buf(false, true)
				local win = vim.api.nvim_open_win(buf, true, {
					relative = "editor",
					width = width,
					height = height,
					row = row,
					col = col,
					style = "minimal",
					border = "rounded",
					title = " C++ Run ",
					title_pos = "center",
				})

				vim.fn.termopen(filename .. ".exe")
				vim.cmd("startinsert")

				-- Keymap để đóng floating window
				vim.keymap.set("n", "<Esc>", function()
					vim.api.nvim_win_close(win, true)
				end, { buffer = buf })

				vim.keymap.set("t", "<Esc>", function()
					vim.api.nvim_win_close(win, true)
				end, { buffer = buf })
			end, {
				buffer = true,
				desc = "Chạy executable C/C++ (floating)",
			})
		end,
	})

	-- Keymap riêng cho C# (nếu cần override debug behavior)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "cs",
		callback = function()
			-- F5 vẫn giữ nguyên cho debug
			-- Có thể thêm F9 để compile C#
			vim.keymap.set("n", "<F9>", function()
				vim.cmd("w")
				vim.cmd("split | terminal")
				vim.cmd("startinsert")
				local file = vim.fn.expand("%:p")
				local compile_cmd = string.format('dotnet run "%s"', file)
				vim.fn.feedkeys(compile_cmd .. "\r")
			end, {
				buffer = true,
				desc = "Chạy C# với dotnet run",
			})
		end,
	})
end

return M
