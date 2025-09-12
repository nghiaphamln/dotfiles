return {
	"rcarriga/nvim-dap-ui",
	dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup({
			icons = { expanded = "▾", collapsed = "▸" },
			mappings = {
				expand = { "<CR>", "<2-LeftMouse>" },
				open = "o",
				remove = "d",
				edit = "e",
				repl = "r",
				toggle = "t",
			},
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.25 },
						{ id = "breakpoints", size = 0.25 },
						{ id = "stacks", size = 0.25 },
						{ id = "watches", size = 0.25 },
					},
					size = 40,
					position = "left",
				},
				{
					elements = {
						{ id = "repl", size = 0.5 },
						{ id = "console", size = 0.5 },
					},
					size = 10,
					position = "bottom",
				},
			},
			floating = {
				max_height = 0.8,
				max_width = 0.8,
				border = "rounded",
				mappings = {
					close = { "q", "<Esc>" },
				},
			},
		})

		-- Function để tìm và chọn project với Telescope-style UI
		local function select_dotnet_project_float()
			local cwd = vim.fn.getcwd()
			local projects = {}
			
			-- Tìm tất cả file .csproj
			local csproj_files = vim.fn.glob(cwd .. "/**/*.csproj", true, true)
			
			for _, csproj in ipairs(csproj_files) do
				local project_dir = vim.fn.fnamemodify(csproj, ":h")
				local project_name = vim.fn.fnamemodify(csproj, ":t:r")
				
				table.insert(projects, {
					name = project_name,
					dir = project_dir,
					csproj = csproj,
					display = project_name .. " (" .. vim.fn.fnamemodify(project_dir, ":~:.") .. ")"
				})
			end
			
			if #projects == 0 then
				vim.notify("No .NET projects found!", vim.log.levels.ERROR)
				return
			end
			
			return projects
		end

		-- Custom floating window cho project selection
		local function create_project_selector(projects, callback)
			local buf = vim.api.nvim_create_buf(false, true)
			local width = 60
			local height = math.min(#projects + 4, 20)
			
			-- Tính toán vị trí center
			local row = math.floor((vim.o.lines - height) / 2)
			local col = math.floor((vim.o.columns - width) / 2)
			
			-- Tạo content
			local lines = { "Select Project to Debug:", "" }
			for i, project in ipairs(projects) do
				table.insert(lines, string.format("%d. %s", i, project.display))
			end
			table.insert(lines, "")
			table.insert(lines, "Press number or 'q' to cancel")
			
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
			vim.api.nvim_buf_set_option(buf, "modifiable", false)
			
			-- Tạo floating window
			local win = vim.api.nvim_open_win(buf, true, {
				relative = "editor",
				width = width,
				height = height,
				row = row,
				col = col,
				style = "minimal",
				border = "rounded",
				title = " .NET Projects ",
				title_pos = "center",
			})
			
			-- Set highlight
			vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal,FloatBorder:FloatBorder")
			
			-- Keymaps cho selection
			for i, project in ipairs(projects) do
				vim.api.nvim_buf_set_keymap(buf, "n", tostring(i), "", {
					callback = function()
						vim.api.nvim_win_close(win, true)
						callback(project)
					end,
					noremap = true,
					silent = true,
				})
			end
			
			-- Close keymap
			vim.api.nvim_buf_set_keymap(buf, "n", "q", "", {
				callback = function()
					vim.api.nvim_win_close(win, true)
				end,
				noremap = true,
				silent = true,
			})
			
			vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "", {
				callback = function()
					vim.api.nvim_win_close(win, true)
				end,
				noremap = true,
				silent = true,
			})
		end

		-- Custom floating window cho profile selection
		local function create_profile_selector(profiles, project_name, callback)
			local buf = vim.api.nvim_create_buf(false, true)
			local width = 50
			local height = math.min(#profiles + 4, 15)
			
			local row = math.floor((vim.o.lines - height) / 2)
			local col = math.floor((vim.o.columns - width) / 2)
			
			local lines = { "Select Launch Profile for " .. project_name .. ":", "" }
			local profile_list = {}
			local i = 1
			for profile_name, _ in pairs(profiles) do
				table.insert(profile_list, profile_name)
				table.insert(lines, string.format("%d. %s", i, profile_name))
				i = i + 1
			end
			table.insert(lines, "")
			table.insert(lines, "Press number or 'q' to cancel")
			
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
			vim.api.nvim_buf_set_option(buf, "modifiable", false)
			
			local win = vim.api.nvim_open_win(buf, true, {
				relative = "editor",
				width = width,
				height = height,
				row = row,
				col = col,
				style = "minimal",
				border = "rounded",
				title = " Launch Profiles ",
				title_pos = "center",
			})
			
			vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal,FloatBorder:FloatBorder")
			
			-- Keymaps cho profile selection
			for idx, profile_name in ipairs(profile_list) do
				vim.api.nvim_buf_set_keymap(buf, "n", tostring(idx), "", {
					callback = function()
						vim.api.nvim_win_close(win, true)
						callback(profile_name)
					end,
					noremap = true,
					silent = true,
				})
			end
			
			-- Close keymaps
			vim.api.nvim_buf_set_keymap(buf, "n", "q", "", {
				callback = function()
					vim.api.nvim_win_close(win, true)
				end,
				noremap = true,
				silent = true,
			})
			
			vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "", {
				callback = function()
					vim.api.nvim_win_close(win, true)
				end,
				noremap = true,
				silent = true,
			})
		end

		-- Helper function để đọc launchSettings.json
		local function get_launch_settings(project_dir)
			local launch_settings_path = project_dir .. "/Properties/launchSettings.json"
			
			if vim.fn.filereadable(launch_settings_path) == 1 then
				local content = vim.fn.readfile(launch_settings_path)
				local json_str = table.concat(content, "\n")
				
				local ok, parsed = pcall(vim.json.decode, json_str)
				if ok and parsed.profiles then
					return parsed.profiles
				end
			end
			
			return nil
		end

		-- Function để build project với Debug configuration
		local function build_project(project_dir)
			local build_cmd = "dotnet build " .. vim.fn.shellescape(project_dir) .. " --configuration Debug"
			local result = vim.fn.system(build_cmd)
			local exit_code = vim.v.shell_error
			
			if exit_code == 0 then
				vim.notify("✅ Debug build successful: " .. vim.fn.fnamemodify(project_dir, ":t"), vim.log.levels.INFO)
				return true
			else
				vim.notify("❌ Debug build failed:\n" .. result, vim.log.levels.ERROR)
				return false
			end
		end

		-- Function để tìm DLL sau khi build
		local function find_dll(project_dir, project_name)
			local debug_paths = {
				project_dir .. "/bin/Debug/net8.0/" .. project_name .. ".dll",
				project_dir .. "/bin/Debug/net7.0/" .. project_name .. ".dll",
				project_dir .. "/bin/Debug/net6.0/" .. project_name .. ".dll",
				project_dir .. "/bin/Debug/netcoreapp3.1/" .. project_name .. ".dll",
			}
			
			for _, path in ipairs(debug_paths) do
				if vim.fn.filereadable(path) == 1 then
					return path
				end
			end
			
			local debug_pattern = project_dir .. "/bin/Debug/**/" .. project_name .. ".dll"
			local debug_files = vim.fn.glob(debug_pattern, true, true)
			
			if #debug_files > 0 then
				return debug_files[1]
			end
			
			local release_pattern = project_dir .. "/bin/Release/**/" .. project_name .. ".dll"
			local release_files = vim.fn.glob(release_pattern, true, true)
			
			if #release_files > 0 then
				vim.notify("⚠️  Warning: Only Release build found! Debug experience will be limited.", vim.log.levels.WARN)
				return release_files[1]
			end
			
			return nil
		end

		-- Function để mở browser
		local function open_browser(url)
			if url then
				vim.fn.system('explorer "' .. url .. '"')
				vim.notify("🌐 Browser opened: " .. url, vim.log.levels.INFO)
			end
		end

		-- Function để extract URL từ applicationUrl
		local function get_browser_url(profile)
			if profile.applicationUrl then
				local urls = vim.split(profile.applicationUrl, ";")
				return urls[1]
			end
			return nil
		end

		-- Function để start debug với profile
		local function start_debug_with_profile(project, profile_name, profile)
			local dll_path = find_dll(project.dir, project.name)
			if not dll_path then
				vim.notify("❌ DLL not found for project: " .. project.name, vim.log.levels.ERROR)
				return
			end
			
			local env_vars = profile and profile.environmentVariables or {}
			env_vars["DEBUG_LAUNCH_PROFILE"] = profile_name
			env_vars["DEBUG_PROJECT_NAME"] = project.name
			
			if profile and profile.applicationUrl then
				env_vars["ASPNETCORE_URLS"] = profile.applicationUrl
			end
			
			vim.notify("🚀 Starting debug: " .. project.name .. " [Profile: " .. profile_name .. "]", vim.log.levels.INFO)
			
			dap.run({
				type = "coreclr",
				name = "Launch " .. project.name .. " (" .. profile_name .. ")",
				request = "launch",
				program = dll_path,
				cwd = project.dir,
				args = {},
				env = env_vars,
				stopAtEntry = false,
				console = "integratedTerminal",
			})
			
			-- Mở browser nếu cần
			if profile and profile.launchBrowser then
				local browser_url = get_browser_url(profile)
				if browser_url then
					vim.defer_fn(function()
						open_browser(browser_url)
					end, 3000)
				end
			end
		end

		-- Main function để debug project
		local function debug_dotnet_project()
			local projects = select_dotnet_project_float()
			if not projects then return end
			
			if #projects == 1 then
				local project = projects[1]
				if not build_project(project.dir) then return end
				
				local launch_settings = get_launch_settings(project.dir)
				if launch_settings then
					create_profile_selector(launch_settings, project.name, function(selected_profile)
						local profile = launch_settings[selected_profile]
						start_debug_with_profile(project, selected_profile, profile)
					end)
				else
					start_debug_with_profile(project, "Default", nil)
				end
			else
				create_project_selector(projects, function(selected_project)
					if not build_project(selected_project.dir) then return end
					
					local launch_settings = get_launch_settings(selected_project.dir)
					if launch_settings then
						create_profile_selector(launch_settings, selected_project.name, function(selected_profile)
							local profile = launch_settings[selected_profile]
							start_debug_with_profile(selected_project, selected_profile, profile)
						end)
					else
						start_debug_with_profile(selected_project, "Default", nil)
					end
				end)
			end
		end

		dap.adapters.coreclr = {
			type = "executable",
			command = "netcoredbg",
			args = { "--interpreter=vscode" },
		}

		dap.configurations.cs = {
			{
				type = "coreclr",
				name = "Launch .NET Core (Debug)",
				request = "launch",
				program = function()
					local cwd = vim.fn.getcwd()
					local dll_files = vim.fn.glob(cwd .. "/**/bin/Debug/**/*.dll", true, true)

					if #dll_files > 0 then
						for _, dll in ipairs(dll_files) do
							local filename = vim.fn.fnamemodify(dll, ":t:r")
							local dir_name = vim.fn.fnamemodify(cwd, ":t")
							if filename == dir_name then
								return dll
							end
						end
						return dll_files[1]
					end

					return vim.fn.input("Path to DEBUG dll: ", cwd .. "/bin/Debug/", "file")
				end,
				cwd = "${workspaceFolder}",
				args = {},
				stopAtEntry = false,
				console = "integratedTerminal",
				justMyCode = false,
				enableStepFiltering = false,
				logging = {
					moduleLoad = false,
					engineLogging = false,
				},
			},
			{
				type = "coreclr",
				name = "Attach to process",
				request = "attach",
				processId = function()
					return require("dap.utils").pick_process()
				end,
				cwd = "${workspaceFolder}",
				justMyCode = false,
			},
		}

		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		-- Keymaps
		vim.keymap.set("n", "<F5>", debug_dotnet_project, { desc = "Debug: Select & Start .NET Project" })
		vim.keymap.set("n", "<leader><F5>", dap.continue, { desc = "Debug: Continue" })
		vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
		vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
		vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
		vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
		vim.keymap.set("n", "<leader>B", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Debug: Set Conditional Breakpoint" })
		vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })
		vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug: Run Last" })
		vim.keymap.set("n", "<leader>dt", dapui.toggle, { desc = "Debug: Toggle UI" })
		
		vim.keymap.set("n", "<leader>db", function()
			local url = vim.fn.input("Enter URL to open: ", "https://localhost:")
			if url and url ~= "" then
				open_browser(url)
			end
		end, { desc = "Open browser with URL" })
	end,
}