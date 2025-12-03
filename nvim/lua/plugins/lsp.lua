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
          local opts = { buffer = ev.buf, silent = true, noremap = true }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          -- Custom keymaps per user preference
          vim.keymap.set("n", "gi", function()
            require("telescope.builtin").lsp_implementations()
          end, opts)
          vim.keymap.set("n", "gu", function()
            require("telescope.builtin").lsp_references()
          end, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        end,
      })

      -- Register with which-key (once, outside LspAttach)
      local wk = require("which-key")
      wk.add({
        { "g", group = "LSP" },
        { "gd", desc = "Go to definition" },
        { "gD", desc = "Go to declaration" },
        { "gi", desc = "Go to implementation" },
        { "gu", desc = "Go to usage/references" },
        { "K", desc = "Hover" },
        { "<leader>rn", desc = "Rename" },
        { "<leader>ca", desc = "Code action" },
        { "[d", desc = "Previous diagnostic" },
        { "]d", desc = "Next diagnostic" },
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
      snippets = {
        preset = "default",
      },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
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
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      cmdline = {
        enabled = true,
        keymap = {
          preset = "cmdline",
          ["<Right>"] = false,
          ["<Left>"] = false,
        },
        completion = {
          list = { selection = { preselect = false } },
          menu = {
            auto_show = function(ctx)
              return vim.fn.getcmdtype() == ":"
            end,
          },
          ghost_text = { enabled = true },
        },
      },
      keymap = {
        preset = "enter",
        ["<C-y>"] = { "select_and_accept" },
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_next()
            end
          end,
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
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
