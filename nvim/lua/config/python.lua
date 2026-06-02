local M = {}

M.root_markers = {
	"pyrightconfig.json",
	"pyproject.toml",
	"setup.py",
	"setup.cfg",
	"requirements.txt",
	"Pipfile",
	".git",
}

local function join_paths(...)
	return table.concat({ ... }, "/")
end

local function is_executable(path)
	return path ~= nil and path ~= "" and vim.fn.executable(path) == 1
end

local function project_venv_bin(root, executable)
	if not root or root == "" then
		return nil
	end

	local candidate = join_paths(root, ".venv", "bin", executable)
	if is_executable(candidate) then
		return candidate
	end

	return nil
end

function M.resolve_project_python(root)
	return project_venv_bin(root, "python")
end

function M.resolve_tool(executable, root)
	local from_venv = project_venv_bin(root, executable)
	if from_venv then
		return from_venv
	end

	local from_path = vim.fn.exepath(executable)
	if from_path ~= "" then
		return from_path
	end

	return executable
end

function M.resolve_pyright_cmd()
	local pyright_langserver = vim.fn.exepath("pyright-langserver")
	if pyright_langserver ~= "" then
		return { pyright_langserver, "--stdio" }
	end

	local node = vim.fn.exepath("node")
	local mason_pyright = join_paths(
		vim.fn.stdpath("data"),
		"mason",
		"packages",
		"pyright",
		"node_modules",
		"pyright",
		"langserver.index.js"
	)
	if node ~= "" and vim.fn.filereadable(mason_pyright) == 1 then
		return { node, mason_pyright, "--stdio" }
	end

	return { "pyright-langserver", "--stdio" }
end

function M.append_python_user_bin_to_path()
	local python = vim.fn.exepath("python3")
	if python == "" then
		return
	end

	local lines = vim.fn.systemlist({
		python,
		"-m",
		"site",
		"--user-base",
	})
	if vim.v.shell_error ~= 0 or #lines == 0 then
		return
	end

	local user_base = vim.trim(lines[1])
	if user_base == "" then
		return
	end

	local bin_dir = user_base .. "/bin"
	if vim.fn.isdirectory(bin_dir) ~= 1 or vim.env.PATH:find(bin_dir, 1, true) then
		return
	end

	vim.env.PATH = vim.env.PATH .. ":" .. bin_dir
end

return M
