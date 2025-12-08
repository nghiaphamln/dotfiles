# Neovim Configuration

A modern, feature-rich Neovim configuration with AI integration, LSP support, and extensive customization options.

## Features

### Core Functionality

- **GitHub Copilot Integration** - AI-powered code completion with custom keybindings
- **Auto-save** - Automatically saves files when leaving insert mode or on text changes
- **LSP (Language Server Protocol)** - Full language support for Lua, Rust, Go, and Python
- **Smart Code Completion** - Powered by Blink.cmp with LSP, snippets, and buffer completion
- **Syntax Highlighting** - Advanced highlighting via Treesitter
- **File Navigation** - Neo-tree file explorer for project navigation
- **Fuzzy Finding** - Telescope for efficient file/buffer searching

### Additional Features

- **Formatting & Linting** - Automatic code formatting and linting
- **Git Integration** - Built-in git signs and hunk navigation
- **Visual Enhancements** - Custom status line, indentation guides, and rainbow delimiters
- **Terminal Integration** - Built-in terminal with smart navigation
- **Flash Navigation** - Quick motion commands for efficient movement
- **Diagnostic Integration** - Visual error/warning display with Trouble.nvim

## Installation

### Prerequisites

Before installing this Neovim configuration, ensure you have:

1. **Neovim 0.9+**:

   ```bash
   # On macOS
   brew install neovim

   # On Ubuntu/Debian
   sudo apt install neovim
   ```

2. **Required Language Servers** (for LSP support):
   - `lua-language-server`
   - `rust-analyzer`
   - `gopls`
   - `pyright`

3. **Additional Tools** (for formatting and linting):
   - `stylua` (Lua formatter)
   - `rustfmt` (Rust formatter)
   - `gofmt` (Go formatter)
   - `black` and `isort` (Python formatters)
   - `prettier` (General formatter)
   - `pylint` (Python linter)
   - `clippy` (Rust linter)
   - `golangci-lint` (Go linter)

### Setup

1. **Backup your existing Neovim configuration** (if any):

   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone this repository** to your Neovim configuration directory:

   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   ln -s ~/dotfiles/nvim ~/.config/nvim
   ```

3. **Start Neovim and install plugins**:

   ```bash
   nvim
   ```

   Then run:

   ```vim
   :Lazy sync
   ```

4. **Configure GitHub Copilot** (optional):
   After installation, authenticate with Copilot:
   ```vim
   :Copilot auth
   ```

## Usage

### Basic Keybindings

#### Window Management

- `<C-h/j/k/l>` - Navigate between windows
- `<leader>|` - Vertical split
- `<leader>-` - Horizontal split

#### Buffer Management

- `<S-h>` - Previous buffer
- `<S-l>` - Next buffer
- `<leader>e` - Toggle file explorer

#### File Operations

- `<C-s>` - Save file
- `<Esc>` - Clear search highlights
- `<leader>fm` - Format current file

#### Navigation

- `;` - Flash navigation (quick movement)
- `<leader> ` (space) - Leader key prefix

### LSP Keybindings

#### Code Navigation

- `gd` - Go to definition
- `gD` - Go to declaration
- `gi` - Go to implementation
- `gu` - Go to references
- `K` - Show hover documentation

#### Code Actions

- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `[d` - Previous diagnostic
- `]d` - Next diagnostic

#### Advanced LSP Navigation

- `]]` - Next reference
- `[[` - Previous reference

### GitHub Copilot Keybindings

- `<C-a>` - Accept Copilot suggestion
- `<C-n>` - Next Copilot suggestion
- `<C-p>` - Previous Copilot suggestion
- `<C-]>` - Dismiss current suggestion

### Diagnostic Management

- `<leader>xx` - Toggle Trouble diagnostics
- `<leader>xq` - Toggle QuickFix
- `<leader>xl` - Toggle Location List

## Plugin Configuration

### Core Plugins

#### LSP Configuration

- **mason.nvim** - Package manager for LSP servers, formatters, and linters
- **nvim-lspconfig** - LSP configuration for various language servers
- **blink.cmp** - Fast, lightweight completion plugin
- **trouble.nvim** - Pretty diagnostics list

#### File Management

- **neo-tree.nvim** - File explorer with git integration
- **telescope.nvim** - Fuzzy finder for files, buffers, and more
- **conform.nvim** - Code formatter
- **nvim-lint** - Code linter

#### UI Enhancement

- **lualine.nvim** - Fast and customizable status line
- **which-key.nvim** - Show keybinding hints
- **indent-blankline.nvim** - Indentation guides
- **rainbow-delimiters.nvim** - Colorized delimiters
- **vim-illuminate** - Highlight word under cursor

#### Editing Enhancement

- **treesitter** - Better syntax highlighting
- **mini.pairs** - Automatic bracket completion
- **Comment.nvim** - Comment toggling
- **flash.nvim** - Enhanced motion commands
- **snacks.nvim** - Collection of Neovim utilities

#### AI Integration

- **copilot.lua** - GitHub Copilot integration
- **auto-save.nvim** - Automatic file saving

## Customization

### Adding Plugins

To add new plugins, create a new file in `~/.config/nvim/lua/plugins/` following the same format as existing plugin files.

### Modifying Keybindings

Edit `~/.config/nvim/lua/config/keymaps.lua` to modify existing keybindings or add new ones.

### Modifying Options

Edit `~/.config/nvim/lua/config/options.lua` to change Neovim options like indentation, searching behavior, etc.

## Troubleshooting

### Plugin Installation Issues

If plugins don't install properly:

1. Run `:Lazy sync` to install/update plugins
2. Check `:Lazy` for any errors and resolve them

### LSP Issues

If LSP servers aren't working:

1. Ensure you have the required language servers installed
2. Run `:Mason` to manage LSP servers
3. Check the LSP client status with `:LspInfo`

### Performance Issues

If Neovim feels slow:

1. Check if treesitter parsers are installed with `:checkhealth treesitter`
2. Verify that your terminal supports true colors
3. Consider disabling some visual plugins if needed

### Copilot Not Working

1. Run `:Copilot auth` to authenticate with GitHub Copilot
2. Check Copilot status in the status line
3. Ensure your GitHub account has Copilot access

## License

This configuration is open source and available under the MIT License.

