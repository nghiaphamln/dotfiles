# dotfiles
My Personal Dotfiles for Neovim Configuration

## Overview

This repository contains my personal Neovim configuration files, designed to provide a modern, efficient development environment with VS Code-like features. The configuration includes LSP support, debugging capabilities, and many useful keybindings.

## Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/dotfiles.git ~/.config/nvim
```

2. Install Neovim (v0.10+ recommended)

3. Launch Neovim and run `:Lazy` to install plugins

## Key Features

- LSP (Language Server Protocol) support for code completion and diagnostics
- Built-in debugging support (DAP) with Visual Studio-style keymaps
- File tree navigation with Neo-tree
- Fuzzy finding with Telescope
- Syntax highlighting with Treesitter
- Code formatting and linting
- Git integration with Neogit
- WSL2 clipboard integration

## Keymaps

### Window Management
- `<C-h>`: Move to left window
- `<C-j>`: Move to window below
- `<C-k>`: Move to window above
- `<C-l>`: Move to right window
- `<C-Up>`: Resize window smaller vertically
- `<C-Down>`: Resize window larger vertically
- `<C-Left>`: Resize window smaller horizontally
- `<C-Right>`: Resize window larger horizontally

### Text Editing
- `<A-j>`: Move selected text down (in Visual mode)
- `<A-k>`: Move selected text up (in Visual mode)
- `<` then `v` (in Visual mode): Indent and keep selection
- `>` then `v` (in Visual mode): Outdent and keep selection
- `<C-s>`: Save file

### Window Splitting
- `<leader>sv`: Split window vertically
- `<leader>sh`: Split window horizontally

### File Operations
- `<leader>q`: Quit current window
- `<leader>Q`: Quit all windows without saving

### Diagnostics
- `<leader>ne`: Go to next diagnostic
- `<leader>pe`: Go to previous diagnostic

### Debugging (Visual Studio Style)
All debug keymaps are configured in the debug plugin file and follow Visual Studio conventions:
- `<F5>`: Start/Continue debugging
- `<F9>`: Toggle breakpoint
- `<F10>`: Step over
- `<F11>`: Step into
- `<S-F11>`: Step out (Shift+F11)
- `<C-S-F5>`: Restart debugging (Ctrl+Shift+F5)
- `<A-F5>`: Run to cursor (Alt+F5)
- `<F6>`: Pause debugging
- `<leader>B`: Set conditional breakpoint
- `<leader>dr`: Open REPL
- `<leader>dl`: Run last debug session
- `<leader>dt`: Toggle debug UI



### Other
- `<Esc>`: Clear search highlight
- `Space` (Space key): Used as leader key
- `<leader>` + any key: For additional commands

## Plugin Management

This configuration uses Lazy.nvim for plugin management. Plugins are defined in:
- `nvim/lua/plugins/` directory

## LSP Configuration

LSP servers are configured in `nvim/lua/plugins/language-server-protocol.lua` and include support for:
- Lua (lua_ls)
- C/C++ (clangd)
- Rust (rust_analyzer)

## Debugging Configuration

Debug adapters are configured in:
- `nvim/lua/configurations/debug/dotnet.lua`
- `nvim/lua/configurations/debug/rust.lua`
- `nvim/lua/configurations/debug/shared.lua`

## WSL2 Integration

For WSL2 users, clipboard integration is automatically configured to work with Windows applications using the `unnamedplus` register.

## Customization

To customize this configuration:
1. Modify options in `nvim/lua/configurations/options.lua`
2. Add keymaps in `nvim/lua/configurations/keymaps.lua`
3. Add plugins in `nvim/lua/plugins/` directory

## Contributing

Feel free to open issues or submit pull requests if you find any problems or have suggestions for improvements.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
