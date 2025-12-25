-- Auto Commands
local function augroup(name)
  return vim.api.nvim_create_augroup("config_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Auto-create missing undo directory
local undo_dir = os.getenv("HOME") .. "/.config/nvim/undo"
if vim.fn.isdirectory(undo_dir) == 0 then
  vim.fn.mkdir(undo_dir, "p")
end

-- Disable Copilot if a specific file exists in the project root
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = augroup("copilot_disable"),
  callback = function()
    -- Check if .disable-copilot file exists in the project root
    local project_root = vim.fs.dirname(vim.fs.find({ ".git", ".disable-copilot", "Makefile", "CMakeLists.txt", "compile_commands.json" }, { upward = true })[1] or vim.fn.getcwd())

    if project_root then
      local disable_file = project_root .. "/.disable-copilot"
      if vim.fn.filereadable(disable_file) == 1 then
        -- Set the global variable to disable Copilot for this session
        vim.g.copilot_enabled = false
        -- Try to disable using command immediately
        vim.cmd("silent! Copilot disable")

        -- Also disable for the current buffer specifically
        vim.b.copilot_enabled = false

        -- Try to disable when plugin is available using schedule
        vim.schedule(function()
          local ok, copilot = pcall(require, "copilot")
          if ok and copilot and copilot.disable then
            copilot.disable()
          else
            vim.cmd("silent! Copilot disable")
          end
        end)
      else
        -- If the file doesn't exist but Copilot was disabled, re-enable it
        if vim.g.copilot_enabled == false then
          vim.g.copilot_enabled = true
          vim.cmd("silent! Copilot enable")
        end
      end
    end
  end,
  desc = "Disable Copilot if .disable-copilot file exists in project root",
})
