# Neovim Configuration

A Neovim 0.12+ setup for macOS, focused on LSP, fast completion, AI tooling, Treesitter, and a small set of polished UI plugins.

## Features

### Core Functionality

- **GitHub Copilot Integration** - AI-powered code completion with custom keybindings
- **Auto-save** - Automatically saves files when leaving insert mode or on text changes
- **LSP (Language Server Protocol)** - Full language support for Lua, Rust, Go, Python, C/C++, YAML, and CMake
- **Smart Code Completion** - Powered by Blink.cmp with LSP, snippets, and buffer completion
- **Syntax Highlighting** - Advanced highlighting via Treesitter
- **File Navigation** - Neo-tree file explorer for project navigation
- **Fuzzy Finding** - Telescope for efficient file/buffer searching

### Additional Features

- **Formatting & Linting** - Conform and nvim-lint integration
- **Git Integration** - Built-in git signs and hunk navigation
- **Visual Enhancements** - Custom status line, indentation guides, and rainbow delimiters
- **Terminal Integration** - Built-in terminal with smart navigation
- **Flash Navigation** - Quick motion commands for efficient movement
- **Diagnostic Integration** - Visual error/warning display with Trouble.nvim

## Installation

## Platform Support

- Supported: macOS
- Not officially supported: Linux, Windows, WSL

This configuration currently assumes a macOS-style environment, Homebrew-managed tools, and terminal/tooling behavior that has only been verified on macOS.

### Prerequisites

Before installing this configuration, ensure you have:

1. **Neovim 0.12+**:

   ```bash
   # On macOS
   brew install neovim

   ```

2. **Node.js + npm**:
   Needed for `pyright`, `prettier`, `@mermaid-js/mermaid-cli`, and `tree-sitter-cli`.

3. **Required macOS tools**:
   Install the tools intentionally managed outside Mason with Homebrew:

   ```bash
   brew install clang-format cmake-language-server ghostscript stylua
   python3 -m pip install --user cmakelang
   npm install -g @mermaid-js/mermaid-cli tree-sitter-cli@0.25.10
   ```

   Notes:
   - `cmake-language-server` is intentionally installed with Homebrew instead of Mason because current Mason packaging rejects Python 3.14.
   - `cmake-format` comes from the `cmakelang` Python package.

4. **Language tools managed automatically by Mason**:
   - `lua-language-server`
   - `rust-analyzer`
   - `gopls`
   - `pyright`
   - `yaml-language-server`
   - `clangd`
   - `clang-format`
   - `stylua`
   - `cppcheck`

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

3. **Install the required external tools**:

   - Run the Homebrew/npm/pip commands from the prerequisites section above.

4. **Start Neovim and install plugins and Mason packages**:

   ```bash
   nvim
   ```

   Then run:

   ```vim
   :Lazy sync
   ```

5. **Configure GitHub Copilot** (optional):
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
- `[b` - Previous buffer
- `]b` - Next buffer
- `<leader>bp` - Toggle pin buffer
- `<leader>bP` - Close unpinned buffers
- `<leader>br` - Close buffers to the right
- `<leader>bl` - Close buffers to the left
- `<leader>bo` - Close other buffers (keep only current)
- `<leader>bc` - Close current buffer

#### File Operations

- `<C-s>` - Save file
- `<Esc>` - Clear search highlights
- `<leader>fm` - Format current file
- `<leader>e` - Toggle file explorer

#### Navigation

- `;` - Flash navigation (quick movement)
- `<leader>` - Leader key prefix

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
- `<leader>td` - Toggle diagnostics (Trouble)

### GitHub Copilot Keybindings

- `<C-a>` - Accept Copilot suggestion
- `<C-n>` - Next Copilot suggestion
- `<C-p>` - Previous Copilot suggestion
- `<C-]>` - Dismiss current suggestion

### Copilot Chat Keybindings

- `<leader>cc` - Toggle Copilot Chat
- `<leader>cx` - Clear Chat
- `<leader>cq` - Quick Chat
- `<leader>cp` - Prompt Actions
- `<leader>cb` - Add Buffer to Chat
- `<leader>ce` - Explain Code
- `<leader>cr` - Review Code
- `<leader>cf` - Fix Bug
- `<leader>co` - Optimize Code

### Diagnostic Management

- `<leader>xx` - Toggle Trouble diagnostics
- `<leader>xq` - Toggle QuickFix
- `<leader>xl` - Toggle Location List

### File and Search Operations

- `<leader>ff` - Find files
- `<leader>fw` - Find word in files
- `<leader><leader>` - Recent files
- `<leader>fb` - Buffers
- `<leader>fh` - Help tags

### Git Operations

- `<leader>gg` - Open LazyGit

### Terminal Operations

- `<C-\>` - Toggle terminal
- `<C-h/j/k/l>` in terminal - Navigate between windows

### Comment Operations

- `gcc` - Toggle line comment
- `gbc` - Toggle block comment

### Formatting Operations

- `<leader>fc` - Format buffer
- `<leader>fm` - Format current file

### Utility Operations

- `<leader>.` - Toggle scratch buffer
- `<leader>S` - Select scratch buffer

## Plugin Configuration

### Core Plugins

#### LSP Configuration

- **mason.nvim** - Package manager for most LSP servers and developer tools
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
- **CopilotChat.nvim** - Chat with Copilot in Neovim
- **auto-save.nvim** - Automatic file saving

## Customization

### Adding Plugins

To add new plugins, create a new file in `nvim/lua/plugins/` following the same format as the existing plugin files.

### Modifying Keybindings

Edit `nvim/lua/config/keymaps.lua` to modify existing keybindings or add new ones.

### Modifying Options

Edit `nvim/lua/config/options.lua` to change Neovim options like indentation, searching behavior, and environment setup.

## Troubleshooting

### Plugin Installation Issues

If plugins don't install properly:

1. Run `:Lazy sync` to install/update plugins
2. Check `:Lazy` for any errors and resolve them
3. Run `./nvim/tests/checkhealth_smoke.sh` from the dotfiles repo to verify the upgraded config

### LSP Issues

If LSP servers aren't working:

1. Run `:Mason` to confirm Mason-managed servers are installed
2. Check the active LSP client state with `:LspInfo`
3. Confirm Homebrew-managed tools such as `cmake-language-server` are on `PATH`
4. If Neovim was just upgraded, run `./nvim/tests/checkhealth_smoke.sh`

### Performance Issues

If Neovim feels slow:

1. Check if Treesitter parsers are installed with `:checkhealth treesitter`
2. Verify that your terminal supports true colors
3. Consider disabling some visual plugins if needed

### Health Checks

After changing plugins or upgrading Neovim, run:

```bash
./nvim/tests/checkhealth_smoke.sh
```

If `vim.lsp` warns that the log file is too large, truncate it with:

```bash
: > "$HOME/.local/state/nvim/lsp.log"
```

### Copilot Not Working

1. Run `:Copilot auth` to authenticate with GitHub Copilot
2. Check Copilot status in the status line
3. Ensure your GitHub account has Copilot access

## License

This configuration is open source and available under the MIT License.
