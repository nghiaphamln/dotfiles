# dotfiles

Personal development environment configuration for Neovim, Zed, Kitty, IdeaVim, OpenCode, and PowerShell.

## Structure

```
dotfiles/
├── nvim/              → ~/.config/nvim
├── zed/               → ~/.config/zed
├── kitty/             → ~/.config/kitty
├── IdeaVim/           → ~/.ideavimrc
├── PowerShell/        → PowerShell profile
├── opencode/          → ~/.config/opencode/{opencode.jsonc,package.json}
├── github-copilot/    → Copilot version tracking
└── docs/              → Documentation
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

See [opencode/README.md](opencode/README.md) for detailed setup instructions.

```bash
mkdir -p ~/.config/opencode

ln -sf ~/dotfiles/opencode/opencode.jsonc ~/.config/opencode/opencode.jsonc
ln -sf ~/dotfiles/opencode/package.json ~/.config/opencode/package.json

# Set API keys in ~/.zshenv — see opencode/README.md
```

Superpowers is installed by OpenCode from the `plugin` entry in `opencode/opencode.jsonc`.

## Tools

| Tool | Config | Purpose |
|---|---|---|
| [Neovim](https://neovim.io/) | `nvim/` | Primary editor |
| [Zed](https://zed.dev/) | `zed/` | Secondary editor |
| [Kitty](https://sw.kovidgoyal.net/kitty/) | `kitty/` | Terminal emulator |
| [IdeaVim](https://github.com/JetBrains/ideavim) | `IdeaVim/` | Vim emulation in JetBrains IDEs |
| [OpenCode](https://opencode.ai/) | `opencode/` | AI coding agent (terminal) |
| PowerShell | `PowerShell/` | Shell profile (Windows) |
| GitHub Copilot | `github-copilot/` | Copilot version tracking |

## Neovim

Requires Neovim 0.12+. Launch Neovim — [lazy.nvim](https://github.com/folke/lazy.nvim) will auto-install plugins on first run.

Install language servers:
```
:Mason
```

**Key plugins:**
- **LSP**: `nvim-lspconfig` + Mason (Rust, Go, Python, Lua, C/C++, YAML, CMake)
- **Completion**: `blink.cmp`
- **Syntax**: `nvim-treesitter`
- **File explorer**: `neo-tree.nvim`
- **Fuzzy finder**: `snacks.picker`
- **Formatter**: `conform.nvim`
- **Theme**: `tokyonight.nvim`
- **Statusline**: `lualine.nvim`
- **AI**: `copilot.lua` + `CopilotChat.nvim`

See [nvim/README.md](nvim/README.md) for full documentation.

## Update Superpowers

```bash
restart OpenCode
```
