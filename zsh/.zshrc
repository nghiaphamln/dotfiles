# Interactive Zsh configuration.

# Smarter `cd` powered by directory history.
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

# Per-user tools and the .NET SDK installed by Microsoft's install script.
export DOTNET_ROOT="$HOME/.dotnet"
typeset -U path PATH
path=("$HOME/.local/bin" "$DOTNET_ROOT" "$DOTNET_ROOT/tools" $path)

# Node.js version management.
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
fi
if [[ -s "$NVM_DIR/bash_completion" ]]; then
  source "$NVM_DIR/bash_completion"
fi

# Gruvbox prompt managed by Oh My Posh.
_omp_config="$HOME/.config/oh-my-posh/gruvbox.omp.json"
if (( $+commands[oh-my-posh] )) && [[ -r "$_omp_config" ]]; then
  eval "$(oh-my-posh init zsh --config "$_omp_config")"
fi
unset _omp_config

# Fish-like inline suggestions sourced from shell history.
_zsh_autosuggestions="${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
if [[ -r "$_zsh_autosuggestions" ]]; then
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
  source "$_zsh_autosuggestions"
fi
unset _zsh_autosuggestions
