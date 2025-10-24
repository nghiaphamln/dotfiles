local M = {}

-- Custom floating window cho project selection
function M.create_project_selector(projects, callback)
	local buf = vim.api.nvim_create_buf(false, true)
	local width = 60
	local height = math.min(#projects + 4, 20)

	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local lines = { "Select Project to Debug:", "" }
	for i, project in ipairs(projects) do
		local icon = project.type == "rust" and "🦀" or "🔷"
		table.insert(lines, string.format("%d. %s %s", i, icon, project.display))
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
		title = " Projects ",
		title_pos = "center",
	})

	vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal,FloatBorder:FloatBorder")

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

function M.setup(dap, dapui)
	-- Main F5 debug function with support for multiple project types
	local function debug_project()
		local rust_projects = {}
		local has_rust = pcall(function()
			local rust = require("configurations.debug.rust")
			rust_projects = rust.find_projects() or {}
			
			for _, project in ipairs(rust_projects) do
				project.type = "rust"
			end
		end)
		
		-- Combine all projects
		local all_projects = {}
		vim.list_extend(all_projects, rust_projects)

		if #all_projects == 0 then
			vim.notify("No projects found!", vim.log.levels.ERROR)
			return
		end

		if #all_projects == 1 then
			local project = all_projects[1]
			if project.type == "rust" then
				local rust = require("configurations.debug.rust")
				rust.start_debug(project)
			end
		else
			M.create_project_selector(all_projects, function(selected_project)
				if selected_project.type == "rust" then
					local rust = require("configurations.debug.rust")
					rust.start_debug(selected_project)
				end
			end)
		end
	end

	vim.keymap.set("n", "<F5>", debug_project, { desc = "Debug: Select & Start Project" })
end

return M
