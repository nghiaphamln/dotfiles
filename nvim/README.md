# Neovim Configuration

A modern, modular Neovim configuration with project detection and language-specific debugging support.

## Features

- **Modular Architecture**: Clean separation of concerns with core, plugins, and project detection
- **Project Detection**: Automatically detects project type (Rust, .NET, Node.js, etc.) and configures settings accordingly
- **VS-Style Debugging**: Familiar keymaps for debugging (F5, F10, F11) that work per project type
- **Lazy Loading**: Optimized startup time with plugin lazy loading
- **Comprehensive Plugin Suite**: LSP, completion, treesitter, debugging, and more

## Installation

1. **Backup your existing Neovim configuration** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim_backup
   ```

2. **Clone this repository**:
   ```bash
   git clone <repository-url> ~/.config/nvim
   ```

3. **Launch Neovim**:
   ```bash
   nvim
   ```
   The configuration will automatically install lazy.nvim and all plugins on first launch.

## Module Structure

The configuration is organized into the following modules:

- `lua/core/`: Core Neovim settings, keymaps, autocommands
- `lua/plugins/`: Plugin configurations organized by functionality
- `lua/projects/`: Project detection and language-specific configurations

## Key Mappings

### Global Key Mappings

| Key | Description |
| --- | ----------- |
| `<Space>` | Leader key |
| `<C-h>` | Move to left window |
| `<C-j>` | Move to down window |
| `<C-k>` | Move to up window |
| `<C-l>` | Move to right window |
| `<C-Up>` | Resize window taller |
| `<C-Down>` | Resize window shorter |
| `<C-Left>` | Resize window wider |
| `<C-Right>` | Resize window narrower |
| `<A-j>` / `<A-k>` | Move selected lines up/down in visual mode |
| `<Esc>` | Clear search highlights |
| `<C-s>` | Save file |
| `<leader>sv` | Vertical split |
| `<leader>sh` | Horizontal split |
| `<leader>q` | Quit |
| `<leader>Q` | Quit all |
| `<leader>ne` | Next diagnostic |
| `<leader>pe` | Previous diagnostic |

### Plugin-Specific Key Mappings

#### File Explorer (Neo-tree)
| Key | Description |
| --- | ----------- |
| `<leader>e` | Toggle explorer |
| `<leader>ef` | Focus explorer |

#### Buffer Management (Bufferline)
| Key | Description |
| --- | ----------- |
| `<S-l>` | Next buffer |
| `<S-h>` | Previous buffer |

#### Telescope (Fuzzy Finder)
| Key | Description |
| --- | ----------- |
| `<leader>ff` | Find files |
| `<leader>fw` | Grep current word |
| `<leader><leader>` | Recent files |

#### LSP (Language Server Protocol)
| Key | Description |
| --- | ----------- |
| `gd` | Go to definition |
| `gi` | Go to implementation |
| `gu` | Go to references |
| `ca` | Code action |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>fd` | Show diagnostics |

#### Debugging
The configuration provides VS-Style debugging keymaps that activate automatically when working with supported project types:

| Key | Description |
| --- | ----------- |
| `F5` | Start/Continue debugging |
| `F10` | Step Over |
| `F11` | Step Into |
| `Shift+F11` | Step Out |
| `F9` | Toggle Breakpoint |

#### Formatting
| Key | Description |
| --- | ----------- |
| `<leader>fc` | Format file |

#### Debug UI
| Key | Description |
| --- | ----------- |
| `<leader>dr` | Open REPL |
| `<leader>dl` | Run last debug session |
| `<leader>dt` | Toggle debug UI |

## Project Detection System

The configuration includes an intelligent project detection system that automatically:

- Detects project type based on files in the project root (e.g., `Cargo.toml`, `package.json`, `.csproj`)
- Sets appropriate indentation and tab settings per project type (Rust uses 4 spaces, Node.js uses 2 spaces, etc.)
- Enables VS-style debugging keymaps when supported project types are detected
- Allows selection between multiple projects in a workspace

### Supported Project Types

- Rust (with `Cargo.toml`)
- .NET (with `.csproj` files)
- Node.js (with `package.json`)
- Python (with `requirements.txt`, `pyproject.toml`, etc.)
- Go (with `go.mod`)
- C/C++ (with `CMakeLists.txt`, `.c`, `.cpp` files)

## Plugin List

### UI Plugins
- **lualine.nvim**: Status line
- **bufferline.nvim**: Tab/buffer line
- **neo-tree.nvim**: File explorer
- **toggleterm.nvim**: Floating terminal
- **telescope.nvim**: Fuzzy finder
- **catppuccin**: Color scheme

### Editing Plugins
- **nvim-autopairs**: Auto pairs for brackets, quotes, etc.
- **copilot.vim**: GitHub Copilot integration

### LSP & Completion
- **nvim-lspconfig**: LSP configuration
- **mason.nvim**: Package manager for LSP servers
- **nvim-cmp**: Completion engine
- **cmp-nvim-lsp**: LSP completion source

### Syntax & Highlighting
- **nvim-treesitter**: Syntax highlighting and parsing

### Git
- **neogit**: Git interface

### Debugging
- **nvim-dap**: Debug Adapter Protocol
- **nvim-dap-ui**: Debug UI
- **codelldb**: Rust debugger
- **netcoredbg**: .NET debugger

### Formatting
- **formatter.nvim**: Code formatter

## Configuration Files

### Core Configuration
- `lua/core/options.lua` - Vim options
- `lua/core/keymaps.lua` - Key mappings
- `lua/core/autocmds.lua` - Autocommands
- `lua/core/utils.lua` - Utility functions

### Plugin Configuration
- `lua/plugins/ui.lua` - UI plugins (status line, file explorer, etc.)
- `lua/plugins/editing.lua` - Editing plugins (auto-pairs, etc.)
- `lua/plugins/lsp/init.lua` - LSP configuration
- `lua/plugins/lsp/mason.lua` - Mason configuration
- `lua/plugins/completion/init.lua` - Completion configuration
- `lua/plugins/treesitter/init.lua` - Treesitter configuration
- `lua/plugins/git/init.lua` - Git plugins configuration
- `lua/plugins/debug/init.lua` - Debugging configuration
- `lua/plugins/formatting.lua` - Formatting configuration

### Project Detection
- `lua/projects/init.lua` - Project detection system
- `lua/projects/debug.lua` - Project-specific debugging

## Customization

To customize the configuration:

1. **Modify keymaps**: Edit `lua/core/keymaps.lua`
2. **Change options**: Edit `lua/core/options.lua`
3. **Add plugins**: Add to the appropriate file in `lua/plugins/`
4. **Add project types**: Extend `lua/projects/init.lua`

## Troubleshooting

### Plugin Installation Issues
If plugins fail to install, ensure you have an internet connection and try running:
```bash
:Lazy sync
```

### Language Server Issues
If LSP servers are not working, install them using Mason:
```vim
:Mason
```

### Debugging Not Working
Ensure you have the appropriate debug adapter installed:
- For Rust: Install `codelldb`
- For .NET: Install `netcoredbg`

## Contributing

Feel free to fork this repository and submit pull requests for improvements. The modular structure makes it easy to add new functionality without affecting other parts of the configuration.