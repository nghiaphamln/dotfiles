local M = {}

-- Function to find Rust projects in the current workspace
function M.find_rust_projects()
  local cwd = vim.fn.getcwd()
  local projects = {}
  
  local cargo_files = vim.fn.glob(cwd .. "/**/Cargo.toml", true, true)
  
  for _, cargo_file in ipairs(cargo_files) do
    local project_dir = vim.fn.fnamemodify(cargo_file, ":h")
    local project_name = vim.fn.fnamemodify(cargo_file, ":t:r")
    
    -- Read Cargo.toml to get package name
    local cargo_content = vim.fn.readfile(cargo_file)
    local package_name = project_name
    
    for _, line in ipairs(cargo_content) do
      local name_match = line:match('^name%s*=%s*"([^"]+)"')
      if name_match then
        package_name = name_match
        break
      end
    end
    
    table.insert(projects, {
      name = package_name,
      dir = project_dir,
      cargo_file = cargo_file,
      display = package_name .. " (" .. vim.fn.fnamemodify(project_dir, ":~:.") .. ")",
      type = "rust"
    })
  end
  
  return projects
end

-- Function to find .NET projects in the current workspace
function M.find_dotnet_projects()
  local cwd = vim.fn.getcwd()
  local projects = {}

  local csproj_files = vim.fn.glob(cwd .. "/**/*.csproj", true, true)

  for _, csproj in ipairs(csproj_files) do
    local project_dir = vim.fn.fnamemodify(csproj, ":h")
    local project_name = vim.fn.fnamemodify(csproj, ":t:r")

    table.insert(projects, {
      name = project_name,
      dir = project_dir,
      csproj = csproj,
      display = project_name .. " (" .. vim.fn.fnamemodify(project_dir, ":~:.") .. ")",
      type = "dotnet",
    })
  end

  return projects
end

-- Create project selector UI
function M.create_project_selector(projects, callback)
  if #projects == 0 then
    vim.notify("No projects found!", vim.log.levels.ERROR)
    return
  end

  if #projects == 1 then
    callback(projects[1])
    return
  end

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

-- Function to start debugging based on project type
function M.start_debug()
  local project_type = vim.g.current_project_type
  
  if not project_type then
    -- If no project type detected, try to find projects of different types
    local dotnet_projects = M.find_dotnet_projects() or {}
    local rust_projects = M.find_rust_projects() or {}

    for _, project in ipairs(rust_projects) do
      project.type = "rust"
    end
    for _, project in ipairs(dotnet_projects) do
      project.type = "dotnet"
    end

    local all_projects = {}
    vim.list_extend(all_projects, rust_projects)
    vim.list_extend(all_projects, dotnet_projects)

    if #all_projects == 0 then
      vim.notify("No .NET or Rust projects found in current directory!", vim.log.levels.ERROR)
      return
    end

    if #all_projects == 1 then
      local project = all_projects[1]
      if project.type == "rust" then
        M.start_rust_debug_project(project)
      else
        M.start_dotnet_debug_project(project)
      end
    else
      M.create_project_selector(all_projects, function(selected_project)
        if selected_project.type == "rust" then
          M.start_rust_debug_project(selected_project)
        else
          M.start_dotnet_debug_project(selected_project)
        end
      end)
    end
    return
  end
  
  -- If project type is detected, use current directory
  if project_type == "rust" then
    M.start_rust_debug()
  elseif project_type == "dotnet" then
    M.start_dotnet_debug()
  else
    vim.notify("Debugging not configured for project type: " .. project_type, vim.log.levels.WARN)
  end
end

-- Rust debugging function for current directory
function M.start_rust_debug()
  local dap = require("dap")
  local cwd = vim.fn.getcwd()
  
  -- Find Cargo.toml to verify this is a Rust project
  local cargo_file = cwd .. "/Cargo.toml"
  if vim.fn.filereadable(cargo_file) == 0 then
    vim.notify("No Cargo.toml found in current directory", vim.log.levels.ERROR)
    return
  end
  
  -- Read Cargo.toml to get package name
  local cargo_content = vim.fn.readfile(cargo_file)
  local package_name = vim.fn.fnamemodify(cwd, ":t") -- Default to directory name
  
  for _, line in ipairs(cargo_content) do
    local name_match = line:match('^name%s*=%s*"([^"]+)"')
    if name_match then
      package_name = name_match
      break
    end
  end
  
  -- Find the executable
  local exe_path = cwd .. "/target/debug/" .. package_name
  if vim.fn.has("win32") == 1 then
    exe_path = exe_path .. ".exe"
  end
  
  if vim.fn.executable(exe_path) ~= 1 then
    vim.notify("Executable not found: " .. exe_path, vim.log.levels.ERROR)
    return
  end
  
  -- Start debugging
  dap.run({
    type = "codelldb",
    name = "Debug Rust: " .. package_name,
    request = "launch",
    program = exe_path,
    cwd = cwd,
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  })
  
  vim.notify("Started debugging Rust project: " .. package_name, vim.log.levels.INFO)
end

-- .NET debugging function for current directory
function M.start_dotnet_debug()
  local dap = require("dap")
  local cwd = vim.fn.getcwd()
  
  -- Find .csproj file
  local csproj_files = vim.fn.glob(cwd .. "/*.csproj", true, true)
  
  if #csproj_files == 0 then
    vim.notify("No .csproj file found in current directory", vim.log.levels.ERROR)
    return
  end
  
  local csproj = csproj_files[1]
  local project_name = vim.fn.fnamemodify(csproj, ":t:r")
  
  -- Find DLL in bin/Debug directory
  local dll_path = cwd .. "/bin/Debug/net8.0/" .. project_name .. ".dll"
  if vim.fn.filereadable(dll_path) == 0 then
    -- Try other .NET versions
    local versions = {"net7.0", "net6.0", "net5.0", "netcoreapp3.1"}
    for _, version in ipairs(versions) do
      local test_path = cwd .. "/bin/Debug/" .. version .. "/" .. project_name .. ".dll"
      if vim.fn.filereadable(test_path) == 1 then
        dll_path = test_path
        break
      end
    end
    
    if vim.fn.filereadable(dll_path) == 0 then
      vim.notify("No debug DLL found for project: " .. project_name, vim.log.levels.ERROR)
      return
    end
  end
  
  -- Start debugging
  dap.run({
    type = "coreclr",
    name = "Launch .NET Core: " .. project_name,
    request = "launch",
    program = dll_path,
    cwd = cwd,
    args = {},
    stopAtEntry = false,
    console = "integratedTerminal",
  })
  
  vim.notify("Started debugging .NET project: " .. project_name, vim.log.levels.INFO)
end

-- Rust debugging function for a specific project (used with project selector)
function M.start_rust_debug_project(project)
  local dap = require("dap")
  
  -- Build the project first
  local build_result = vim.fn.system("cd " .. vim.fn.shellescape(project.dir) .. " && cargo build")
  local exit_code = vim.v.shell_error
  
  if exit_code ~= 0 then
    vim.notify("Build failed: " .. build_result, vim.log.levels.ERROR)
    return
  end
  
  -- Find the executable
  local exe_path = project.dir .. "/target/debug/" .. project.name
  if vim.fn.has("win32") == 1 then
    exe_path = exe_path .. ".exe"
  end
  
  if vim.fn.executable(exe_path) ~= 1 then
    vim.notify("Executable not found: " .. exe_path, vim.log.levels.ERROR)
    return
  end
  
  -- Start debugging
  dap.run({
    type = "codelldb",
    name = "Debug Rust: " .. project.name,
    request = "launch",
    program = exe_path,
    cwd = project.dir,
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  })
  
  vim.notify("Started debugging Rust project: " .. project.name, vim.log.levels.INFO)
end

-- .NET debugging function for a specific project (used with project selector)
function M.start_dotnet_debug_project(project)
  local dap = require("dap")
  
  -- Build the project first
  local build_result = vim.fn.system("cd " .. vim.fn.shellescape(project.dir) .. " && dotnet build")
  local exit_code = vim.v.shell_error
  
  if exit_code ~= 0 then
    vim.notify("Build failed: " .. build_result, vim.log.levels.ERROR)
    return
  end
  
  -- Find the DLL
  local project_name = vim.fn.fnamemodify(project.csproj, ":t:r")
  local dll_path = project.dir .. "/bin/Debug/net8.0/" .. project_name .. ".dll"
  
  if vim.fn.filereadable(dll_path) == 0 then
    -- Try other .NET versions
    local versions = {"net7.0", "net6.0", "net5.0", "netcoreapp3.1"}
    for _, version in ipairs(versions) do
      local test_path = project.dir .. "/bin/Debug/" .. version .. "/" .. project_name .. ".dll"
      if vim.fn.filereadable(test_path) == 1 then
        dll_path = test_path
        break
      end
    end
    
    if vim.fn.filereadable(dll_path) == 0 then
      vim.notify("No debug DLL found for project: " .. project_name, vim.log.levels.ERROR)
      return
    end
  end
  
  -- Start debugging
  dap.run({
    type = "coreclr",
    name = "Launch .NET Core: " .. project_name,
    request = "launch",
    program = dll_path,
    cwd = project.dir,
    args = {},
    stopAtEntry = false,
    console = "integratedTerminal",
  })
  
  vim.notify("Started debugging .NET project: " .. project_name, vim.log.levels.INFO)
end

return M