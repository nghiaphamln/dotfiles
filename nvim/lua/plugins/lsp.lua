-- LSP Configuration for Rust, Go, Python, Lua

return {
  -- Mason: Package manager for LSP, formatters, linters
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "rust-analyzer",
        "gopls",
        "pyright",
      },
    },
  },

  -- Mason LSPConfig: Bridge between Mason and LSPConfig
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = {
      handlers = {
        function(server_name)
          vim.lsp.config(server_name):setup({})
        end,
      },
    },
  },

  -- LSPConfig: Configure language servers
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-lspconfig.nvim" },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Lua LS
      vim.lsp.config["lua_ls"] = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_dir = vim.fs.find(".luarc.json", { upward = true })[1] or vim.fn.getcwd(),
        capabilities = capabilities,
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
            },
          },
        },
      }

      -- Rust Analyzer
      vim.lsp.config["rust_analyzer"] = {
        cmd = { "rust-analyzer" },
        filetypes = { "rust" },
        root_dir = vim.fs.find("Cargo.toml", { upward = true })[1] or vim.fn.getcwd(),
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            diagnostics = {
              enable = true,
            },
          },
        },
      }

      -- Gopls
      vim.lsp.config["gopls"] = {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = vim.fs.find("go.mod", { upward = true })[1] or vim.fn.getcwd(),
        capabilities = capabilities,
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
          },
        },
      }

      -- Pyright
      vim.lsp.config["pyright"] = {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_dir = vim.fs.find("pyproject.toml", { upward = true })[1] or vim.fn.getcwd(),
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
            },
          },
        },
      }

      -- LSP Keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

          -- Register with which-key
          local wk = require("which-key")
          wk.add({
            { "g", group = "LSP" },
            { "gd", vim.lsp.buf.definition, desc = "Go to definition" },
            { "gD", vim.lsp.buf.declaration, desc = "Go to declaration" },
            { "gi", vim.lsp.buf.implementation, desc = "Go to implementation" },
            { "gr", vim.lsp.buf.references, desc = "Go to references" },
            { "K", vim.lsp.buf.hover, desc = "Hover" },
            { "<leader>rn", vim.lsp.buf.rename, desc = "Rename" },
            { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action" },
            { "[d", vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
            { "]d", vim.diagnostic.goto_next, desc = "Next diagnostic" },
          }, { buffer = ev.buf })
        end,
      })
    end,
  },

  -- Blink.cmp: Fast completion with LSP support
  {
    "saghen/blink.cmp",
    lazy = false,
    build = "cargo build --release",
    dependencies = "rafamadriz/friendly-snippets",
    opts = {
      keymap = {
        preset = "default",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide" },
        ["<C-y>"] = { "select_and_accept" },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      cmdline = {
        sources = { "buffer", "cmdline" },
      },
      completion = {
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
    },
  },

  -- Diagnostic display
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
      { "<leader>xq", "<cmd>Trouble quickfix toggle<cr>", desc = "QuickFix" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
    },
    opts = {},
  },
}
