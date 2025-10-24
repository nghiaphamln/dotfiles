local M = {}

-- Function to detect project type based on files in the root directory
function M.detect_project_type()
  local cwd = vim.fn.getcwd()
  
  -- Define project type patterns
  local project_patterns = {
    rust = {
      files = { "Cargo.toml", "rust-toolchain", "rust-toolchain.toml" },
      dirs = { ".cargo" }
    },
    dotnet = {
      files = { "*.csproj", "*.fsproj", "*.vbproj", "global.json" }
    },
    node = {
      files = { "package.json", "yarn.lock", "pnpm-lock.yaml" }
    },
    python = {
      files = { "requirements.txt", "pyproject.toml", "poetry.lock", "Pipfile" },
      dirs = { "venv", ".venv", "env", ".env" }
    },
    go = {
      files = { "go.mod", "go.sum" }
    },
    lua = {
      files = { "init.lua", ".luarc.json" }
    },
    c = {
      files = { "CMakeLists.txt", "Makefile", "*.c", "*.h" }
    },
    cpp = {
      files = { "CMakeLists.txt", "Makefile", "*.cpp", "*.cxx", "*.cc", "*.c", "*.h", "*.hpp", "*.hxx" }
    }
  }
  
  -- Check each directory for project-specific files
  for project_type, patterns in pairs(project_patterns) do
    if patterns.files then
      for _, file_pattern in ipairs(patterns.files) do
        -- Use glob to check for files
        local matches = vim.fn.glob(cwd .. "/" .. file_pattern, false, true)
        if #matches > 0 then
          return project_type
        end
      end
    end
    
    if patterns.dirs then
      for _, dir_name in ipairs(patterns.dirs) do
        local dir_path = cwd .. "/" .. dir_name
        local stat = vim.loop.fs_stat(dir_path)
        if stat and stat.type == "directory" then
          return project_type
        end
      end
    end
  end
  
  return nil
end

-- Function to load project-specific configuration
function M.load_project_config()
  local project_type = M.detect_project_type()
  
  if project_type then
    vim.notify("Detected project type: " .. project_type, vim.log.levels.INFO)
    
    -- Store current project type for use elsewhere
    vim.g.current_project_type = project_type
    
    -- Set specific options based on project type
    if project_type == "rust" then
      -- Rust-specific configurations
      vim.opt_local.expandtab = true
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.g.rust_recommended_style = true
    elseif project_type == "dotnet" then
      -- .NET-specific configurations
      vim.opt_local.expandtab = true
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
    elseif project_type == "node" then
      -- Node.js-specific configurations
      vim.opt_local.expandtab = true
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
    end
    
    -- Setup project-specific keymaps
    M.setup_project_keymaps(project_type)
    
    return project_type
  end
  
  return nil
end

-- Function to setup project-specific keymaps
function M.setup_project_keymaps(project_type)
  -- Clear any existing project keymaps
  if vim.g.project_keymaps_set then
    -- Remove previous keymaps if needed
    -- This is a simplified implementation
  end
  
  -- Set up common debugging keymaps for all projects that support debugging
  if project_type == "rust" or project_type == "dotnet" then
    -- VS-style debugging keymaps
    vim.keymap.set("n", "<F5>", function()
      require("projects.debug").start_debug()
    end, { desc = "Debug: Start/Continue" })
    
    vim.keymap.set("n", "<F10>", function()
      require("dap").step_over()
    end, { desc = "Debug: Step Over" })
    
    vim.keymap.set("n", "<F11>", function()
      require("dap").step_into()
    end, { desc = "Debug: Step Into" })
    
    vim.keymap.set("n", "<Shift-F11>", function()
      require("dap").step_out()
    end, { desc = "Debug: Step Out" })
    
    vim.keymap.set("n", "<F9>", function()
      require("dap").toggle_breakpoint()
    end, { desc = "Debug: Toggle Breakpoint" })
    
    vim.g.project_keymaps_set = true
  end
end

-- Function to setup autocommands for project detection
function M.setup_autocmds()
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
      -- Only run if the directory changed
      local current_dir = vim.fn.getcwd()
      if not vim.g.last_project_dir or vim.g.last_project_dir ~= current_dir then
        vim.g.last_project_dir = current_dir
        M.load_project_config()
      end
    end,
    desc = "Auto-detect project type on directory change",
  })
  
  -- Also run when neovim starts
  M.load_project_config()
end

return M