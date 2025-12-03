# Neovim Configuration

Modern, fully-featured Neovim configuration with LSP support for Rust, Go, Python, and Lua.

## ✨ Features

- 🎨 **Theme**: Tokyonight (Moon) - Beautiful dark theme
- 📁 **File Manager**: Neo-tree with intuitive keyboard navigation
- 💻 **LSP**: Full IDE support (Rust, Go, Python, Lua)
- 🔍 **Completion**: Blink.cmp (fast Rust-based completion engine)
- 📝 **Formatting**: Conform (auto-format on save)
- 🔎 **Fuzzy Finder**: Telescope (files, grep, buffers, help)
- 🎮 **Terminal**: Toggleterm (floating terminal)
- 📊 **Diagnostics**: Trouble (error/warning viewer)
- 💡 **Git**: LazyGit integration
- 🌳 **Syntax**: Treesitter (9+ language parsers)
- ✏️ **Editor**: Auto-pairs, comments, rainbow delimiters, indent guides, word highlight
- 🚀 **Dashboard**: Beautiful startup screen with quick actions
- ⌨️ **Keymaps**: 17+ intuitive shortcuts

## 🚀 Quick Start

```bash
# Create symlink
ln -s ~/Work/Nexorion/dotfiles/nvim ~/.config/nvim

# Open nvim (lazy.nvim auto-installs plugins)
nvim

# Inside nvim, install LSP servers
:Mason
```

### Essential Commands

```
Space + ff   → Find files
Space + fw   → Search words
Space + e    → Toggle file explorer
Space + gg   → LazyGit
Ctrl + \     → Floating terminal
Space + fm   → Format file
```

## 🎯 Supported Languages

| Language | LSP | Format | Lint | Syntax |
|----------|-----|--------|------|--------|
| **Lua** | ✅ | stylua | selene | ✅ |
| **Rust** | ✅ | rustfmt | clippy | ✅ |
| **Go** | ✅ | gofmt | golangci-lint | ✅ |
| **Python** | ✅ | black/isort | pylint | ✅ |
| **JavaScript** | ❌ | prettier | - | ✅ |
| **JSON** | ❌ | prettier | - | ✅ |

## 📂 Project Structure

```
nvim/
├── init.lua
├── lua/config/         (99 lines - options, keymaps, autocmds)
└── lua/plugins/        (549 lines - 5 plugin files)
    ├── init.lua        (core UI - 3 plugins)
    ├── lsp.lua         (language servers - 6 plugins)
    ├── format-lint.lua (formatting/linting - 2 plugins)
    ├── utils.lua       (tools - 5 plugins)
    └── editor.lua      (enhancements - 8 plugins)
```

## 📊 Statistics

- **28+ plugins** organized in 5 categories
- **4 languages** with full IDE support
- **~648 lines** of config (minimal!)
- **17+ keybindings** for core operations

## ⌨️ Key Bindings

| Mode | Key | Action |
|------|-----|--------|
| Normal | `<C-s>` | Save |
| Normal | `<C-h/j/k/l>` | Navigate windows |
| Normal | `<S-h/l>` | Prev/next buffer |
| Normal | `<leader>e` | Toggle file explorer |
| Normal | `<leader>ff` | Find files |
| Normal | `<leader>fw` | Find word (grep) |
| Normal | `<leader>gg` | LazyGit |
| Normal | `<C-\>` | Toggle terminal |
| Normal | `<leader>fm` | Format buffer |
| Normal | `gd` | Go to definition |
| Normal | `K` | Hover docs |
| Normal | `<leader>rn` | Rename |
| Normal | `gcc` / `gbc` | Comment line/block |

## 🔧 Customization

Add new plugins in `lua/plugins/custom.lua`:

```lua
return {
  {
    "author/plugin",
    event = "VeryLazy",
    opts = { /* config */ },
  },
}
```

## 📝 Notes

- All plugins lazy-load for fast startup
- LSP servers auto-install via Mason
- Auto-format on save enabled
- Full mouse support

---

**Status**: Production-ready ✅  
**Symlink**: `~/.config/nvim → ~/Work/Nexorion/dotfiles/nvim`
