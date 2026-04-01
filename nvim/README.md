# Neovim Configuration

A Neovim 0.12+ setup for macOS, focused on LSP, fast completion, AI tooling, Treesitter, and a polished UI.

## Features

### Core

- **LSP** — Full language support for Lua, Rust, Go, Python, C/C++, CMake, YAML
- **Smart Completion** — Blink.cmp with LSP, snippets, path, and buffer sources
- **AI Integration** — GitHub Copilot inline suggestions + CopilotChat.nvim
- **Syntax Highlighting** — Treesitter with 25+ parsers
- **File Explorer** — Neo-tree with git integration
- **Fuzzy Finding** — Snacks.picker for files, buffers, grep, LSP symbols, help
- **Auto-save** — Saves on BufLeave, QuitPre, and VimSuspend

### UI & UX

- **Statusline** — Lualine with Copilot status indicator
- **Buffer Tabs** — Bufferline with pin/close/group operations
- **Dashboard** — Snacks dashboard with quick actions on startup
- **Notifications** — Noice.nvim for beautiful messages and cmdline
- **Indent Guides** — Indent-blankline with custom character
- **Rainbow Delimiters** — Colorized bracket nesting
- **Word Highlight** — vim-illuminate highlights word under cursor
- **Symbol Usage** — Inline reference/definition/implementation counts
- **Treesitter Context** — Sticky function/class header at top of viewport
- **Which-key** — Keybinding hints on partial keypress

### Git

- **Gitsigns** — Inline hunks, blame, stage/reset, diff
- **LazyGit** — Full-featured terminal git client (`<leader>gg`)

### Formatting & Linting

- **Conform.nvim** — Async formatting (stylua, black, isort, rustfmt, gofmt, clang-format, cmake_format, prettier)
- **nvim-lint** — Auto-lint on write (pylint, clippy, selene, golangci-lint, cppcheck)

### Editing

- **mini.pairs** — Auto-close brackets and quotes
- **ts-comments.nvim** — Treesitter-aware comment toggling
- **nvim-spider** — Subword-aware `w/e/b/ge` motions for code navigation
- **Flash.nvim** — Rapid cursor movement with `;`
- **Todo Comments** — Highlight and jump between TODO/FIXME/HACK/NOTE

### Tools

- **Toggleterm** — Floating terminal (`<C-\>`)
- **Crates.nvim** — Rust dependency management
- **Markview.nvim** — Rendered markdown preview
- **Scratch Buffers** — Quick notes via Snacks (`<leader>.`)

## Installation

### Platform Support

- **Supported:** macOS
- **Not officially supported:** Linux, Windows, WSL

### Prerequisites

1. **Neovim 0.12+**

   ```bash
   brew install neovim
   ```

2. **Node.js + npm** — Needed for pyright, prettier, mermaid-cli, tree-sitter-cli

3. **macOS tools** (managed outside Mason via Homebrew/npm/pip)

   ```bash
   brew install clang-format cmake-language-server ghostscript stylua
   python3 -m pip install --user cmakelang
   npm install -g @mermaid-js/mermaid-cli tree-sitter-cli@0.25.10
   ```

   Notes:
   - `cmake-language-server` is installed with Homebrew because current Mason packaging rejects Python 3.14
   - `cmake-format` comes from the `cmakelang` Python package

4. **Mason-managed tools** (installed automatically on first run)

   | Tool | Language |
   |------|----------|
   | `lua-language-server` | Lua |
   | `rust-analyzer` | Rust |
   | `gopls` | Go |
   | `pyright` | Python |
   | `yaml-language-server` | YAML |
   | `clangd` | C/C++ |
   | `clang-format` | C/C++ |
   | `stylua` | Lua |
   | `cppcheck` | C/C++ |

### Setup

1. **Backup existing config** (if any)

   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone and symlink**

   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   ln -s ~/dotfiles/nvim ~/.config/nvim
   ```

3. **Install external tools** — Run the Homebrew/npm/pip commands from prerequisites above

4. **Start Neovim and sync plugins**

   ```bash
   nvim
   ```

   Then run:

   ```vim
   :Lazy sync
   ```

5. **Authenticate Copilot** (optional)

   ```vim
   :Copilot auth
   ```

## Usage

### Keybindings

#### General

| Key | Action |
|-----|--------|
| `<C-s>` | Save file |
| `<Esc>` | Clear search highlights |
| `<leader>e` | Toggle file explorer (Neo-tree) |
| `<leader>fm` | Format current file |
| `<leader>ff` | Find files |
| `<leader>fw` | Find word (grep) |
| `<leader><leader>` | Recent files |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>ft` | Find TODOs |
| `<leader>gg` | Open LazyGit |
| `<C-\>` | Toggle terminal |
| `<leader>.` | Toggle scratch buffer |
| `<leader>S` | Select scratch buffer |

#### Window Navigation

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Move between windows |
| `<leader>\|` | Vertical split |
| `<leader>-` | Horizontal split |

#### Buffer Management

| Key | Action |
|-----|--------|
| `<S-h>` / `[b` | Previous buffer |
| `<S-l>` / `]b` | Next buffer |
| `<leader>bp` | Toggle pin buffer |
| `<leader>bP` | Close unpinned buffers |
| `<leader>br` | Close buffers to the right |
| `<leader>bl` | Close buffers to the left |
| `<leader>bo` | Close other buffers |
| `<leader>bc` | Close current buffer |

#### Navigation

| Key | Action |
|-----|--------|
| `w` / `e` / `b` / `ge` | Spider subword motions |
| `;` | Flash jump |
| `<C-space>` | Flash Treesitter selection |
| `j` / `k` | Move by display line (wrap-aware) |
| `]t` / `[t` | Next / previous todo |

#### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gu` | Go to references |
| `K` | Hover documentation |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename symbol |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `]]` / `[[` | Next / previous reference |
| `<leader>td` | Toggle Trouble diagnostics |

#### Diagnostics

| Key | Action |
|-----|--------|
| `<leader>xx` | Toggle Trouble diagnostics |
| `<leader>xq` | Toggle QuickFix |
| `<leader>xl` | Toggle Location List |

#### Copilot

| Key | Action |
|-----|--------|
| `<C-a>` | Accept suggestion |
| `<C-n>` | Next suggestion |
| `<C-p>` | Previous suggestion |
| `<C-]>` | Dismiss suggestion |

#### Copilot Chat

| Key | Action |
|-----|--------|
| `<leader>cc` | Toggle chat |
| `<leader>cx` | Clear/reset chat |
| `<leader>cq` | Quick chat (input prompt) |
| `<leader>cp` | Prompt actions |
| `<leader>cb` | Add buffer to chat |
| `<leader>ce` | Explain code |
| `<leader>cr` | Review code |
| `<leader>cf` | Fix bug |
| `<leader>co` | Optimize code |

#### Noice (Messages)

| Key | Action |
|-----|--------|
| `<leader>snl` | Last message |
| `<leader>snh` | Message history |
| `<leader>sna` | All messages |
| `<leader>snd` | Dismiss all |
| `<leader>snt` | Message picker |
| `<C-f>` / `<C-b>` | Scroll forward/backward |

## Plugin List

### Core

| Plugin | Purpose |
|--------|---------|
| `lazy.nvim` | Plugin manager |
| `mason.nvim` | LSP/formatter/linter package manager |
| `mason-lspconfig.nvim` | Bridge between Mason and LSP |
| `mason-tool-installer.nvim` | Auto-install Mason packages |
| `nvim-lspconfig` | LSP server configuration |
| `blink.cmp` | Completion engine |
| `lazydev.nvim` | Lua development support |
| `fidget.nvim` | LSP progress indicator |

### Completion & AI

| Plugin | Purpose |
|--------|---------|
| `copilot.lua` | GitHub Copilot inline suggestions |
| `CopilotChat.nvim` | Chat interface for Copilot |
| `friendly-snippets` | Snippet collection |

### Editor

| Plugin | Purpose |
|--------|---------|
| `nvim-treesitter` | Syntax highlighting and parsing |
| `nvim-treesitter-context` | Sticky context header |
| `rainbow-delimiters.nvim` | Colorized brackets |
| `indent-blankline.nvim` | Indentation guides |
| `vim-illuminate` | Word under cursor highlight |
| `which-key.nvim` | Keybinding hints |
| `todo-comments.nvim` | TODO/FIXME highlighting |
| `symbol-usage.nvim` | Inline reference counts |
| `flash.nvim` | Fast cursor movement |

### Editing

| Plugin | Purpose |
|--------|---------|
| `mini.pairs` | Auto-close brackets/quotes |
| `ts-comments.nvim` | Treesitter-aware comments |
| `nvim-spider` | Subword-aware word motions |
| `conform.nvim` | Code formatting |
| `nvim-lint` | Code linting |

### UI

| Plugin | Purpose |
|--------|---------|
| `tokyonight.nvim` | Colorscheme (moon style) |
| `mini.icons` | File/type icons |
| `bufferline.nvim` | Buffer tabs |
| `lualine.nvim` | Statusline |
| `snacks.nvim` | Dashboard, picker, scratch, notifier |
| `noice.nvim` | Messages and cmdline UI |
| `trouble.nvim` | Pretty diagnostics list |

### File Management

| Plugin | Purpose |
|--------|---------|
| `neo-tree.nvim` | File explorer |

### Git

| Plugin | Purpose |
|--------|---------|
| `gitsigns.nvim` | Inline git decorations |
| `lazygit.nvim` | Terminal git client |

### Tools

| Plugin | Purpose |
|--------|---------|
| `toggleterm.nvim` | Floating terminal |
| `markview.nvim` | Markdown rendering |
| `crates.nvim` | Rust dependency manager |
| `auto-save.nvim` | Automatic file saving |

## Configuration Structure

```
nvim/
├── init.lua                  # Entry point
├── lua/
│   ├── config/
│   │   ├── init.lua          # Orchestrates config loading
│   │   ├── options.lua       # Vim options (leader, indent, etc.)
│   │   ├── keymaps.lua       # Global keymaps
│   │   ├── autocmds.lua      # Auto commands (yank highlight, Copilot toggle)
│   │   ├── diagnostics.lua   # Diagnostic settings
│   │   └── lazy.lua          # lazy.nvim bootstrap
│   └── plugins/
│       ├── init.lua          # Core UI: icons, colorscheme, bufferline, neo-tree, lualine
│       ├── lsp.lua           # LSP servers, blink.cmp, trouble, fidget, lazydev
│       ├── ai.lua            # Copilot + CopilotChat
│       ├── editor.lua        # Treesitter, rainbow, indent, illuminate, which-key, todos, symbols
│       ├── editing.lua       # mini.pairs, ts-comments
│       ├── format-lint.lua   # conform.nvim, nvim-lint
│       ├── git.lua           # gitsigns, lazygit
│       ├── tools.lua         # toggleterm, markview, crates
│       ├── flash.lua         # flash.nvim
│       ├── snacks.lua        # Dashboard, picker, scratch, notifier
│       ├── noice.lua         # Noice.nvim
│       └── auto-save.lua     # Auto-save
├── undo/                     # Persistent undo files
└── tests/                    # Health check scripts
```

## Customization

### Adding Plugins

Create a new file in `lua/plugins/` following the existing lazy.nvim spec format.

### Modifying Keybindings

Edit `lua/config/keymaps.lua` for global keymaps. Plugin-specific keymaps live in their respective `lua/plugins/*.lua` files.

### Modifying Options

Edit `lua/config/options.lua` for Neovim options (indentation, search, clipboard, etc.).

## Troubleshooting

### Plugin Installation Issues

1. Run `:Lazy sync` to install/update plugins
2. Check `:Lazy` for any errors
3. Run `./nvim/tests/checkhealth_smoke.sh` from the dotfiles repo

### LSP Issues

1. Run `:Mason` to confirm servers are installed
2. Check LSP state with `:LspInfo`
3. Confirm Homebrew tools (`cmake-language-server`, etc.) are on `PATH`
4. If Neovim was upgraded, run `./nvim/tests/checkhealth_smoke.sh`

### LSP Log Too Large

```bash
: > "$HOME/.local/state/nvim/lsp.log"
```

### Copilot Not Working

1. Run `:Copilot auth` to authenticate
2. Check status in the statusline
3. Ensure your GitHub account has Copilot access
4. Check for `.disable-copilot` file in project root

### Performance Issues

1. Check Treesitter parsers: `:checkhealth treesitter`
2. Verify terminal supports true colors
3. Consider disabling visual plugins if needed

## License

MIT
