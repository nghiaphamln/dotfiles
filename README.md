# dotfiles

Personal editor, terminal, and coding-agent configuration.

## Karpathy Guidelines

The shared skill and both plugin manifests live in `skills/karpathy-guidelines/`. [SKILL.md](skills/karpathy-guidelines/skill/SKILL.md) · [Upstream revision (MIT)](https://github.com/multica-ai/andrej-karpathy-skills/tree/2c606141936f1eeef17fa3043a72095b4765b9c2/skills/karpathy-guidelines)

### Codex

Run these commands from any directory to install from GitHub and check for `installed, enabled`.

```bash
codex plugin marketplace add nghiaphamln/dotfiles
codex plugin add karpathy-guidelines@dotfiles
codex plugin list --marketplace dotfiles
```

### OpenCode

OpenCode loads the plugin from its global config. [OpenCode V2 setup](opencode/README.md)

## Dotfiles setup

Clone the repo and run the setup commands from its root. Move existing configs aside before linking.

```bash
git clone https://github.com/nghiaphamln/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### Editors and terminal

[Neovim setup](nvim/README.md) · [Zed keybindings](zed/README.md) · [PowerShell profiles](PowerShell/)

```bash
mkdir -p ~/.config/zed
ln -sf "$PWD/nvim" ~/.config/nvim
ln -sf "$PWD/ghostty" ~/.config/ghostty
ln -sf "$PWD/IdeaVim/.ideavimrc" ~/.ideavimrc
ln -sf "$PWD/zed/settings.json" ~/.config/zed/settings.json
ln -sf "$PWD/zed/keymap.json" ~/.config/zed/keymap.json
```

### Zsh and Oh My Posh

```bash
brew install jandedobbeleer/oh-my-posh/oh-my-posh zsh-autosuggestions
brew install --cask font-jetbrains-mono-nerd-font

PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash'
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
nvm install --lts

curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel 10.0 --install-dir "$HOME/.dotnet"

mkdir -p ~/.config/oh-my-posh
ln -sf "$PWD/zsh/.zshrc" ~/.zshrc
ln -sf "$PWD/zsh/gruvbox.omp.json" ~/.config/oh-my-posh/gruvbox.omp.json
exec zsh
```
