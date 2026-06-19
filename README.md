# dotfiles

Personal development environment configuration for Neovim, Zed, Kitty, IdeaVim, OpenCode, Pi, and PowerShell.

## Structure

```
dotfiles/
├── nvim/              → ~/.config/nvim
├── zed/               → ~/.config/zed
├── kitty/             → ~/.config/kitty
├── IdeaVim/           → ~/.ideavimrc
├── PowerShell/        → PowerShell profile
├── opencode/          → ~/.config/opencode
├── pi/                → ~/.pi/agent/{settings.json,models.json,skills/,prompts/}
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

### OpenCode

See [opencode/README.md](opencode/README.md) for detailed setup instructions.

```bash
ln -sfn ~/dotfiles/opencode ~/.config/opencode

# Set API keys in ~/.zshenv — see opencode/README.md
# Optional token optimization for shell output:
# brew install rtk && restart OpenCode
```

OpenCode setup details, provider environment variables, workflow commands, TUI attention, plugins, and skill layout are documented in [`opencode/README.md`](opencode/README.md).

The checked-in OpenCode plugin currently covers token-optimized shell rewrites via RTK.

### Pi Coding Agent

See [pi/README.md](pi/README.md) for detailed setup instructions.

```bash
mkdir -p ~/.pi/agent

ln -sf ~/dotfiles/pi/agent/settings.json ~/.pi/agent/settings.json
ln -sf ~/dotfiles/pi/agent/models.json ~/.pi/agent/models.json
ln -sf ~/dotfiles/pi/agent/APPEND_SYSTEM.md ~/.pi/agent/APPEND_SYSTEM.md
ln -sf ~/dotfiles/pi/agent/AGENTS.md ~/.pi/agent/AGENTS.md
ln -sfn ~/dotfiles/pi/agent/skills ~/.pi/agent/skills
ln -sfn ~/dotfiles/pi/agent/prompts ~/.pi/agent/prompts
```

Pi setup keeps `~/.pi/agent/auth.json`, sessions, logs, and runtime files local. Only reproducible config is symlinked from dotfiles.

## Tools

| Tool | Config | Purpose |
|---|---|---|
| [Neovim](https://neovim.io/) | `nvim/` | Primary editor |
| [Zed](https://zed.dev/) | `zed/` | Secondary editor |
| [Kitty](https://sw.kovidgoyal.net/kitty/) | `kitty/` | Terminal emulator |
| [IdeaVim](https://github.com/JetBrains/ideavim) | `IdeaVim/` | Vim emulation in JetBrains IDEs |
| [OpenCode](https://opencode.ai/) | `opencode/` | AI coding agent (terminal) |
| [Pi](https://pi.dev/) | `pi/` | AI coding agent (terminal) |
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

## Update OpenCode Config

```bash
restart OpenCode
```
