-- Minimal plugins: colorscheme, file manager, statusline
return {
  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "moon",
    },
  },

  -- File Manager
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = "Toggle File Explorer",
      },
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({ toggle = true, reveal = true })
        end,
        desc = "Toggle File Explorer (Reveal)",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = true,
          hide_gitignored = true,
        },
        window = {
          mappings = {
            ["l"] = "open",
            ["h"] = "close_node",
            ["a"] = { "add", config = { show_path = "none" } },
            ["d"] = "delete",
            ["r"] = "rename",
            ["c"] = "copy",
            ["x"] = "cut",
            ["p"] = "paste",
            ["y"] = "copy_to_clipboard",
          },
        },
      },
    },
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "tokyonight",
        icons_enabled = true,
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
}
