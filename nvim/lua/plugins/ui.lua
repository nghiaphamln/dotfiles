return {
  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = {
          left = "",
          right = "",
        },
        section_separators = {
          left = "",
          right = "",
        },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_last_session = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { {
          "filename",
          path = 1,
        } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { {
          "filename",
          path = 1,
        } },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      extensions = {},
    },
  },
  
  -- Tab/buffer line
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      vim.opt.termguicolors = true
      return {}
    end,
    config = function(_, opts)
      require("bufferline").setup(opts)

      -- Keymaps
      vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>", {
        desc = "Next buffer",
      })
      vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>", {
        desc = "Previous buffer",
      })
    end,
  },
  
  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    opts = {
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
      },
      window = {
        width = 50,
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)

      vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", {
        desc = "Toggle Explorer",
        silent = true,
      })
      vim.keymap.set("n", "<leader>ef", ":Neotree focus<CR>", {
        desc = "Focus Explorer",
        silent = true,
      })
    end,
  },
  
  -- Colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {},
    init = function()
      vim.o.background = "dark"
    end,
    config = function()
      vim.cmd.colorscheme("catppuccin-frappe")
    end,
  },
  
  -- Floating terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      size = 20,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = "pwsh -NoExit",
    },
  },
  
  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        file_ignore_patterns = { "node_modules", ".git/", "dist/" },
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            preview_width = 0.55,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", {
        desc = "Find files",
        silent = true,
      })
      vim.keymap.set("n", "<leader>fw", ":Telescope grep_string<CR>", {
        desc = "Grep current word",
        silent = true,
      })
      vim.keymap.set("n", "<leader><leader>", ":Telescope oldfiles<CR>", {
        desc = "Recent files",
        silent = true,
      })
    end,
  },
}