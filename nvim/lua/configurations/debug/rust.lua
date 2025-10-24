local M = {}

-- Find Rust projects in the current workspace
function M.find_projects()
  local projects = {}
  
  -- Look for Cargo.toml files which indicate Rust projects
  local cargo_files = vim.fn.glob("Cargo.toml", false, true)
  if cargo_files and #cargo_files > 0 then
    for _, cargo_path in ipairs(cargo_files) do
      local project_dir = vim.fn.fnamemodify(cargo_path, ":p:h")
      local project_name = vim.fn.fnamemodify(project_dir, ":t")
      
      table.insert(projects, {
        display = project_name,
        path = project_dir,
        type = "rust",
      })
    end
  end
  
  -- Also search recursively for Cargo.toml files in subdirectories
  local cargo_files_recursive = vim.fn.system({"find", ".", "-name", "Cargo.toml", "-not", "-path", "*/target/*"})
  if vim.v.shell_error == 0 and cargo_files_recursive and cargo_files_recursive ~= "" then
    for cargo_path in cargo_files_recursive:gmatch("[^\r\n]+") do
      if cargo_path and cargo_path ~= "" then
        local project_dir = vim.fn.fnamemodify(cargo_path, ":p:h")
        local project_name = vim.fn.fnamemodify(project_dir, ":t")
        
        -- Avoid duplicates
        local is_duplicate = false
        for _, existing_project in ipairs(projects) do
          if existing_project.path == project_dir then
            is_duplicate = true
            break
          end
        end
        
        if not is_duplicate then
          table.insert(projects, {
            display = project_name,
            path = project_dir,
            type = "rust",
          })
        end
      end
    end
  end
  
  return #projects > 0 and projects or nil
end

-- Start debugging for the given Rust project
function M.start_debug(project)
  local dap = require("dap")
  
  -- Set up rust debug adapter (using codelldb)
  local has_codelldb, codelldb = pcall(require, "dap.ext.vscode")
  if has_codelldb then
    -- Configure codelldb debug adapter
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = "codelldb",
        args = {"--port", "${port}"},
      }
    }
    
    -- Configure rust debug configuration
    dap.configurations.rust = {
      {
        name = "Debug",
        type = "codelldb",
        request = "launch",
        program = function()
          -- Find and return the path to the compiled binary
          local binaries = vim.fn.glob(project.path .. "/target/debug/*.exe", false, true)
          if #binaries > 0 then
            return binaries[1]
          else
            -- Ask user for program path if not found
            return vim.fn.input('Path to executable: ', project.path .. '/target/debug/', 'file')
          end
        end,
        cwd = project.path,
        stopOnEntry = false,
        args = {},
        runInTerminal = true,
      },
    }
  end
  
  -- Start debugging
  dap.run({
    type = "codelldb",
    request = "launch",
    name = "Debug",
    program = function()
      local binaries = vim.fn.glob(project.path .. "/target/debug/*.exe", false, true)
      if #binaries > 0 then
        return binaries[1]
      else
        return vim.fn.input('Path to executable: ', project.path .. '/target/debug/', 'file')
      end
    end,
    cwd = project.path,
    stopOnEntry = false,
    args = {},
    runInTerminal = true,
  })
end

return M