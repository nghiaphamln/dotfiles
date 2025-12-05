-- AI Plugin Configuration: Copilot and related AI tools

return {
  -- copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
        keymap = {
          accept = "<C-a>", -- Accept suggestion with Ctrl+a
          next = "<C-n>",   -- Next suggestion with Ctrl+n
          prev = "<C-p>",   -- Previous suggestion with Ctrl+p
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },

  -- copilot-language-server (ensure it's disabled since copilot.lua has its own)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- copilot.lua only works with its own copilot lsp server
        copilot = { enabled = false },
      },
    },
  },

  -- add ai_accept action for copilot (adapted for non-LazyVim setup)
  {
    "zbirenbaum/copilot.lua",
    opts = function()
      -- Create a helper function to accept copilot suggestions
      if not vim.g.copilot_ai_accept then
        vim.g.copilot_ai_accept = function()
          if package.loaded["copilot.suggestion"] and require("copilot.suggestion").is_visible() then
            require("copilot.suggestion").accept()
            return true
          end
        end
      end
    end,
  },

  -- Add lualine status integration for Copilot (simplified)
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      local function copilot_status()
        local clients = package.loaded["copilot"] and vim.lsp.get_clients({ name = "copilot", bufnr = 0 }) or {}
        if #clients > 0 then
          local status = require("copilot.status").data.status
          if status == "InProgress" then
            return " Active"
          elseif status == "Warning" then
            return " Warning"
          else
            return " Ready"
          end
        end
        return " Off"
      end

      opts.sections = opts.sections or {}
      opts.sections.lualine_x = opts.sections.lualine_x or {}

      -- Add copilot status to the left of the existing components
      table.insert(opts.sections.lualine_x, 1, {
        copilot_status,
        cond = function()
          return package.loaded["copilot"] ~= nil
        end,
      })
    end,
  },

  -- Copilot CMP source integration (for completion)
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "fang2hou/blink-copilot" },
    opts = {
      sources = {
        default = { "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },
}