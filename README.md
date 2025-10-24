# dotfiles

My Personal Dotfiles for Neovim Configuration

<div align="center">

[![Neovim](https://img.shields.io/badge/Neovim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io/)
[![Lua](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org/)
[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/)

</div>

## 📋 Overview

This repository contains my personal Neovim configuration files, designed to provide a modern, efficient development environment with VS Code-like features. The configuration includes LSP support, debugging capabilities, and many useful keybindings. This setup aims to provide an IDE-like experience while maintaining the speed and efficiency of Neovim.

## 🔧 Key Features

- 🌐 **LSP (Language Server Protocol)** support for code completion and diagnostics
- 🐛 **Built-in debugging support** (DAP) with Visual Studio-style keymaps
- 📁 **File tree navigation** with Neo-tree
- 🔍 **Fuzzy finding** with Telescope
- 🌲 **Syntax highlighting** with Treesitter
- 🛠️ **Code formatting and linting**
- 📦 **Git integration** with Gitsigns
- 💻 **WSL2 clipboard integration**
- 🎨 **Modern theme** with Cyberdream colorscheme
- 🤖 **AI-powered completions** with Copilot
- 📰 **Markdown rendering** with enhanced syntax highlighting
- ⌨️ **Intelligent auto-pairing** for brackets/quotes
- 📝 **Buffer management** with bufferline

## 🚀 Installation

1. **Prerequisites**: Ensure you have Neovim (v0.10+ recommended) installed on your system

2. **Clone this repository**:
```bash
git clone https://github.com/yourusername/dotfiles.git ~/.config/nvim
```

3. **Launch Neovim and install plugins**:
```bash
nvim
:Lazy
```
This will automatically install Lazy.nvim (the plugin manager) and all configured plugins. The first launch may take a few minutes depending on the number of plugins.

4. **Install language servers** (using Mason):
```bash
:Mason
```
This opens the Mason UI where you can install language servers for various languages.

## ⌨️ Keymaps

### 🪟 Window Management

| Key | Description |
| --- | --- |
| `<C-h>` | Move to left window |
| `<C-j>` | Move to window below |
| `<C-k>` | Move to window above |
| `<C-l>` | Move to right window |
| `<C-Up>` | Resize window smaller vertically |
| `<C-Down>` | Resize window larger vertically |
| `<C-Left>` | Resize window smaller horizontally |
| `<C-Right>` | Resize window larger horizontally |

### ✏️ Text Editing

| Key | Description |
| --- | --- |
| `<A-j>` | Move selected text down (in Visual mode) |
| `<A-k>` | Move selected text up (in Visual mode) |
| `<` then `v` (in Visual mode) | Indent and keep selection |
| `>` then `v` (in Visual mode) | Outdent and keep selection |
| `<C-s>` | Save file |

### 🗃️ Window Splitting

| Key | Description |
| --- | --- |
| `<leader>sv` | Split window vertically |
| `<leader>sh` | Split window horizontally |

### 📄 File Operations

| Key | Description |
| --- | --- |
| `<leader>q` | Quit current window |
| `<leader>Q` | Quit all windows without saving |
| `<leader>e` | Toggle Explorer (Neo-tree) |
| `<leader>ff` | Find files with Telescope |
| `<leader>fw` | Live grep current word |
| `<leader><leader>` | Open recent files |

### 📊 Diagnostics

| Key | Description |
| --- | --- |
| `<leader>ne` | Go to next diagnostic |
| `<leader>pe` | Go to previous diagnostic |
| `<leader>fd` | Show diagnostics in float |

### 🔍 LSP (Language Server Protocol)

| Key | Description |
| --- | --- |
| `gd` | Go to definition |
| `gi` | Go to implementation |
| `gu` | Go to references |
| `ca` | Code action |
| `K` | Hover documentation |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename symbol |

### 🐛 Debugging (Visual Studio Style)

All debug keymaps follow Visual Studio conventions and work with .NET and Rust projects:

| Key | Description |
| --- | --- |
| `<F5>` | Start/Continue debugging (project selection) |
| `<F9>` | Toggle breakpoint |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<C-S-F5>` | Restart debugging (Ctrl+Shift+F5) |
| `<leader>B` | Set conditional breakpoint |
| `<leader>dr` | Open REPL |
| `<leader>dl` | Run last debug session |
| `<leader>dt` | Toggle debug UI |
| `<leader>db` | Open browser with URL |

### 🔧 C/C++ Compilation and Execution (Floating Windows)

Special keymaps for C/C++ development with floating terminal windows:

| Key | Description |
| --- | --- |
| `<F5>` | Compile and run C/C++ file in floating window |
| `<F6>` | Compile C/C++ file only in floating window |
| `<C-F5>` | Run executable in floating window |

### 📋 Buffer Navigation

| Key | Description |
| --- | --- |
| `<S-l>` | Next buffer |
| `<S-h>` | Previous buffer |

### 🧰 Formatting

| Key | Description |
| --- | --- |
| `<leader>fc` | Format current file |

### 📭 Other

| Key | Description |
| --- | --- |
| `<Esc>` | Clear search highlight |
| `Space` (Space key) | Used as leader key |
| `<leader>` + any key | For additional commands |

## 🧩 Plugin Management

This configuration uses **Lazy.nvim** for plugin management. Plugins are defined in the `nvim/lua/plugins/` directory as separate Lua files. The system automatically loads plugins from this directory and applies their configurations.

Key plugins included:

### 🎨 UI & Appearance
- **cyberdream.nvim** - Modern theme with transparent background
- **lualine.nvim** - Statusline with LSP status and progress
- **bufferline.nvim** - Tab-like buffer management
- **neo-tree.nvim** - File explorer with git integration

### 🔍 Editing
- **nvim-cmp** + **blink.cmp** - Modern autocompletion engine
- **nvim-autopairs** - Auto-insertion of pairs like brackets, quotes
- **treesitter** - Syntax highlighting and code parsing
- **gitsigns.nvim** - Git integration with signs and diff

### 🔍 Fuzzy Finding & Navigation
- **telescope.nvim** - Fuzzy finder for files, buffers, search, etc.
- **nvim-web-devicons** - Icons for files and folders

### 🛠️ Development Support
- **nvim-lspconfig** - Configuration for Language Server Protocol
- **mason.nvim** + **mason-lspconfig.nvim** - Package manager for LSP servers
- **nvim-dap** + **nvim-dap-ui** - Debug Adapter Protocol for debugging
- **formatter.nvim** - Code formatting
- **crates.nvim** - Cargo.toml support for Rust

### 🤖 AI & Tools
- **copilot.vim** - GitHub Copilot integration
- **render-markdown.nvim** - Enhanced Markdown rendering
- **toggleterm.nvim** - Toggle terminal
- **roslyn.nvim** - C# language server support

## 🌐 LSP Configuration

LSP servers are configured in `nvim/lua/plugins/language-server-protocol.lua` and include support for:

- **Lua** (lua_ls) - with proper workspace configuration for Neovim development
- **C/C++** (clangd) - with Windows-specific path configuration
- **Rust** (rust_analyzer) - with proc-macro and check loading enabled
- **C#** (roslyn) - via roslyn.nvim plugin

The configuration includes:
- Enhanced diagnostic display with icons
- Proper capabilities for completion
- Default keymaps for common LSP operations

## 🐛 Debugging Configuration

Multiple debugging configurations are available:

### .NET Debugging
- Integrated .NET CoreCLR debugging support
- Automatic project detection via `*.csproj` files
- Launch profile selection (from `launchSettings.json`)
- Automatic build before debugging
- Browser launching for web applications

### Rust Debugging
- Rust debugging via codelldb
- Project detection through `Cargo.toml`
- Automatic binary detection in `target/debug/`

### Unified Debugging Interface
Debug configurations are unified through `nvim/lua/configurations/debug/shared.lua`, providing a consistent experience for both .NET and Rust projects with:

- Project selection floating window with icons
- Visual Studio-like keymaps
- Integrated debugging UI

## ⚙️ Configuration Structure

The configuration follows a modular structure:

```
nvim/
├── init.lua                    # Main entry point
├── lazy-lock.json             # Plugin lock file (auto-generated)
├── .luarc.json               # Lua LSP configuration
└── lua/
    └── configurations/        # Configuration modules
        ├── keymaps.lua       # Keymap definitions
        ├── options.lua       # Neovim options
        ├── plugins.lua       # Plugin loader
        └── debug/            # Debug configurations
            ├── dotnet.lua
            ├── rust.lua
            └── shared.lua
    └── plugins/              # Plugin configurations
        ├── auto-pairs.lua    # Auto-pairing
        ├── blink.lua         # Modern completion
        ├── bufferline.lua    # Buffer management
        ├── color-schema.lua  # Color scheme
        ├── completion.lua    # Completion setup
        ├── copilot.lua       # GitHub Copilot
        ├── crates.lua        # Rust crates support
        ├── debug-adapter-protocol.lua # Debug adapter
        ├── formatter.lua     # Code formatter
        ├── gitsigns.lua      # Git integration
        ├── language-server-protocol.lua # LSP
        ├── lsp-progress.lua  # LSP progress indicator
        ├── lualine.lua       # Status line
        ├── mason-lspconfig.lua # Mason LSP config
        ├── mason.lua         # Package manager
        ├── neo-tree.lua      # File explorer
        ├── render-markdown.lua # Markdown rendering
        ├── roslyn.lua        # C# support
        ├── telescope.lua     # Fuzzy finder
        ├── toggleterm.lua    # Toggle terminal
        └── treesitter.lua    # Syntax highlighting
```

## 🌍 WSL2 Integration

For WSL2 users, the configuration automatically handles clipboard integration to work with Windows applications using the `unnamedplus` register. This allows for seamless copy/paste between WSL2 and Windows.

## 🎛️ Options Configuration

Neovim options are configured in `nvim/lua/configurations/options.lua` with:

- Line numbers and relative line numbers
- Mouse support enabled
- Smart case-insensitive search
- No search highlight
- Word wrap with break indent
- Tab settings (4 spaces)
- 24-bit color support
- Cursor line highlighting
- Scrolling offset for better context
- Sign column for Git/lint markers
- Split window behavior
- Clipboard integration
- And many other optimizations

## 🛠️ Customization

To customize this configuration:

1. **Modify options** in `nvim/lua/configurations/options.lua`
2. **Add keymaps** in `nvim/lua/configurations/keymaps.lua`
3. **Add plugins** in `nvim/lua/plugins/` directory
4. **Override plugin configurations** by modifying the respective files in `nvim/lua/plugins/`

## 🧪 Languages Supported

This configuration is optimized for:

- **Rust** - With rust_analyzer and crates.nvim
- **C/C++** - With clangd and custom compile/run functions
- **C#** - With roslyn.nvim
- **Lua** - For Neovim configuration development
- **JSON/YAML** - With Treesitter
- **Markdown** - With enhanced rendering
- **Web technologies** - HTML, CSS, JavaScript with Treesitter
- **And many more** - Any language with an LSP server

## 🛡️ Performance Considerations

- Lazy loading is implemented where appropriate
- Treesitter parsers are installed only for specific languages
- Plugin loading is optimized
- LSP completion is optimized with mason.nvim

## 📚 Additional Notes

- The configuration includes C/C++ compile and run functionality with floating windows
- Git integration shows line changes directly in the sign column
- The theme supports both dark and light variants (auto-switching)
- Markdown files get special rendering with enhanced syntax
- Terminal can be toggled with `<C-\>`

## 🤝 Contributing

Feel free to open issues or submit pull requests if you find any problems or have suggestions for improvements. The configuration is designed to be flexible and modular, so contributions that improve the user experience or add new features are welcome.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🌟 Support

If you find this configuration helpful, consider giving it a star on GitHub! It helps others discover this configuration and motivates continued improvements.

---

<div align="center">

Made with 💙 and 🚀

</div>