# dotfiles

Personal development environment configuration for Neovim, Ghostty, Zsh, IdeaVim, OpenCode, and PowerShell.

## Structure

```
dotfiles/
├── nvim/              → ~/.config/nvim
├── ghostty/           → ~/.config/ghostty
├── zsh/               → ~/.zshrc + ~/.config/oh-my-posh/gruvbox.omp.json
├── IdeaVim/           → ~/.ideavimrc
├── PowerShell/        → PowerShell profile
└── opencode/          → ~/.config/opencode
```

## Quick Install

```bash
git clone https://github.com/nghiaphamln/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### Editors & Terminal

```bash
ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/ghostty ~/.config/ghostty
ln -sf ~/dotfiles/IdeaVim/.ideavimrc ~/.ideavimrc
```

### Zsh and Oh My Posh

The custom prompt matches the Gruvbox Dark palette used by Ghostty and expects a Nerd Font. History-based inline command suggestions are provided by `zsh-autosuggestions`, and Node.js versions are managed by `nvm`.

```bash
brew install jandedobbeleer/oh-my-posh/oh-my-posh
brew install zsh-autosuggestions
brew install --cask font-jetbrains-mono-nerd-font

PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash'
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
nvm install --lts

curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel 10.0 --install-dir "$HOME/.dotnet"

mkdir -p ~/.config/oh-my-posh
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/zsh/gruvbox.omp.json ~/.config/oh-my-posh/gruvbox.omp.json
exec zsh
```

### OpenCode

See [opencode/README.md](opencode/README.md) for detailed setup instructions.

```bash
ln -sfn ~/dotfiles/opencode ~/.config/opencode

# Set API keys in ~/.zshenv — see opencode/README.md
```

OpenCode V2 setup, provider environment variables, workflow, CLI settings, and skill layout are documented in [`opencode/README.md`](opencode/README.md). Private runtime `service.json` credentials are not tracked.

## Tools

| Tool | Config | Purpose |
|---|---|---|
| [Neovim](https://neovim.io/) | `nvim/` | Primary editor |
| [Ghostty](https://ghostty.org/) | `ghostty/` | Terminal emulator |
| [Oh My Posh](https://ohmyposh.dev/) | `zsh/` | Gruvbox prompt for Zsh |
| [IdeaVim](https://github.com/JetBrains/ideavim) | `IdeaVim/` | Vim emulation in JetBrains IDEs |
| [OpenCode](https://opencode.ai/) | `opencode/` | AI coding agent (terminal) |
| PowerShell | `PowerShell/` | Shell profile (Windows) |

## Neovim

Requires Neovim 0.12+. Launch Neovim — [lazy.nvim](https://github.com/folke/lazy.nvim) installs plugins at the versions pinned in `nvim/lazy-lock.json`, and Mason installs the declared language tools automatically.

Inspect installed language tools:
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

Edit `opencode/opencode.jsonc` for server settings or `opencode/cli.json` for terminal preferences. Valid edits normally reload automatically. These files use native V2 syntax and should not be used with V1. See [`opencode/README.md`](opencode/README.md) for verification and troubleshooting.
