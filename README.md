# dotfiles

Personal development environment configuration for Neovim, Zed, Kitty, IdeaVim, OpenCode, and PowerShell.

## Structure

```
dotfiles/
├── nvim/           → ~/.config/nvim
├── zed/            → ~/.config/zed
├── kitty/          → ~/.config/kitty
├── IdeaVim/        → ~/.ideavimrc
├── PowerShell/     → PowerShell profile
├── opencode/       → ~/.config/opencode/{opencode.jsonc,package.json}
├── skills/
│   └── superpowers → ../superpowers/skills/   (symlink)
└── superpowers/    → ~/.config/opencode/superpowers  (git clone obra/superpowers)
```

## Quick Install

```bash
git clone https://github.com/nghiaphamln/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### Editors & Terminal

```bash
ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/zed ~/.config/zed
ln -sf ~/dotfiles/kitty ~/.config/kitty
ln -sf ~/dotfiles/IdeaVim/.ideavimrc ~/.ideavimrc
mkdir -p ~/.config/zed/prompts
```

### OpenCode + Superpowers

Xem hướng dẫn chi tiết trong [opencode/README.md](opencode/README.md).

```bash
mkdir -p ~/.config/opencode

ln -sf ~/dotfiles/opencode/opencode.jsonc ~/.config/opencode/opencode.jsonc
ln -sf ~/dotfiles/opencode/package.json ~/.config/opencode/package.json
ln -sf ~/dotfiles/skills ~/.config/opencode/skills
ln -sf ~/dotfiles/superpowers ~/.config/opencode/superpowers

# Khai báo API keys — xem opencode/README.md
```

## Tools

| Tool | Config | Purpose |
|---|---|---|
| [Neovim](https://neovim.io/) | `nvim/` | Primary editor |
| [Zed](https://zed.dev/) | `zed/` | Secondary editor |
| [Kitty](https://sw.kovidgoyal.net/kitty/) | `kitty/` | Terminal emulator |
| [IdeaVim](https://github.com/JetBrains/ideavim) | `IdeaVim/` | Vim emulation in JetBrains IDEs |
| [OpenCode](https://opencode.ai/) | `opencode/` | AI coding agent (terminal) |
| PowerShell | `PowerShell/` | Shell profile (Windows) |

## Neovim

Requires Neovim 0.10+. Launch Neovim — [lazy.nvim](https://github.com/folke/lazy.nvim) tự động cài plugins lần đầu.

Cài language servers:
```
:Mason
```

**Plugins chính:**
- **LSP**: `nvim-lspconfig` + Mason (Rust, Go, Python, Lua, C/C++, YAML)
- **Completion**: `blink.cmp`
- **Syntax**: `nvim-treesitter`
- **File explorer**: `neo-tree.nvim`
- **Fuzzy finder**: `telescope.nvim`
- **Formatter**: `conform.nvim`
- **Theme**: `tokyonight.nvim`
- **Statusline**: `lualine.nvim`
- **AI**: `avante.nvim`

## Update Superpowers

```bash
cd ~/dotfiles/superpowers && git pull
```
