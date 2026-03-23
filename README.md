# dotfiles

Personal development environment configuration for Neovim, Zed IDE, Kitty terminal, IdeaVim, and PowerShell.

## Structure

```
dotfiles/
├── nvim/         → ~/.config/nvim
├── zed/          → ~/.config/zed
├── kitty/        → ~/.config/kitty
├── IdeaVim/      → ~/.ideavimrc
└── PowerShell/   → PowerShell profile
```

## Installation

Clone the repo and create symlinks:

```bash
git clone https://github.com/nghiaphamln/dotfiles.git ~/dotfiles

ln -s ~/dotfiles/nvim ~/.config/nvim
ln -s ~/dotfiles/zed ~/.config/zed
ln -s ~/dotfiles/kitty ~/.config/kitty
ln -s ~/dotfiles/IdeaVim/.ideavimrc ~/.ideavimrc
```

### Neovim

Requires [Neovim](https://neovim.io/) 0.10+. Launch Neovim — [lazy.nvim](https://github.com/folke/lazy.nvim) will auto-install plugins on first run.

Install language servers:

```
:Mason
```

### Zed

Requires [Zed](https://zed.dev/). Settings and keymaps are loaded automatically via the symlink.

After symlinking, recreate the runtime prompts directory (not tracked in git):

```bash
mkdir -p ~/.config/zed/prompts
```

## Tools

| Tool | Config | Purpose |
|---|---|---|
| [Neovim](https://neovim.io/) | `nvim/` | Primary editor |
| [Zed](https://zed.dev/) | `zed/` | Secondary editor |
| [Kitty](https://sw.kovidgoyal.net/kitty/) | `kitty/` | Terminal emulator |
| [IdeaVim](https://github.com/JetBrains/ideavim) | `IdeaVim/` | Vim emulation in JetBrains IDEs |
| PowerShell | `PowerShell/` | Shell profile |

## Neovim Plugins

- **LSP**: `nvim-lspconfig` + Mason (Rust, Go, Python, Lua, C/C++, YAML)
- **Completion**: `blink.cmp`
- **Syntax**: `nvim-treesitter`
- **File explorer**: `neo-tree.nvim`
- **Fuzzy finder**: `telescope.nvim`
- **Formatter**: `conform.nvim`
- **Theme**: `tokyonight.nvim`
- **Statusline**: `lualine.nvim`
- **AI**: `avante.nvim`
