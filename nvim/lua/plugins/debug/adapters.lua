local M = {}

function M.setup(dap, dapui)
  -- Setup .NET CoreCLR adapter
  dap.adapters.coreclr = {
    type = "executable",
    command = "netcoredbg",
    args = { "--interpreter=vscode" },
  }

  -- Setup CodeLLDB adapter for Rust
  dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {
      command = 'codelldb',
      args = {"--port", "${port}"},
    }
  }

  -- .NET configurations
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

  -- Rust configurations
  dap.configurations.rust = {
    {
      type = "codelldb",
      name = "Debug Rust",
      request = "launch",
      program = function()
        local cwd = vim.fn.getcwd()
        local cargo_file = cwd .. "/Cargo.toml"
        
        if vim.fn.filereadable(cargo_file) == 0 then
          return vim.fn.input("Path to executable: ", cwd .. "/target/debug/", "file")
        end
        
        local cargo_content = vim.fn.readfile(cargo_file)
        local package_name = vim.fn.fnamemodify(cwd, ":t")
        
        for _, line in ipairs(cargo_content) do
          local name_match = line:match('^name%s*=%s*"([^"]+)"')
          if name_match then
            package_name = name_match
            break
          end
        end
        
        local exe_path = cwd .. "/target/debug/" .. package_name
        if vim.fn.has("win32") == 1 then
          exe_path = exe_path .. ".exe"
        end
        
        if vim.fn.executable(exe_path) == 1 then
          return exe_path
        end
        
        return vim.fn.input("Path to executable: ", cwd .. "/target/debug/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
      runInTerminal = false,
    },
  }

end

return M