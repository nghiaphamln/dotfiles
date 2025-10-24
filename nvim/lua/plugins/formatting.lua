return {
  -- Formatter
  {
    "mhartington/formatter.nvim",
    event = "VeryLazy",
    opts = function()
      local util = require("formatter.util")

      return {
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = {
          lua = {
            require("formatter.filetypes.lua").stylua,
            function()
              if util.get_current_buffer_file_name() == "special.lua" then
                return nil
              end
              return {
                exe = "stylua",
                args = {
                  "--search-parent-directories",
                  "--stdin-filepath",
                  util.escape_path(util.get_current_buffer_file_path()),
                  "--",
                  "-",
                },
                stdin = true,
              }
            end,
          },
          cs = {
            require("formatter.filetypes.cs").csharpier,
          },
        },
      }
    end,
    config = function(_, opts)
      require("formatter").setup(opts)

      -- Keymaps
      vim.keymap.set("n", "<leader>fc", function()
        vim.cmd("Format")
      end, {
        desc = "Format file",
      })
    end,
  },
}