# Interactive Zsh configuration.

# Smarter `cd` powered by directory history.
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

# Per-user tools and the .NET SDK installed by Microsoft's install script.
export DOTNET_ROOT="$HOME/.dotnet"
typeset -U path PATH
path=("$HOME/.cargo/bin" "$HOME/.local/bin" "$DOTNET_ROOT" "$DOTNET_ROOT/tools" $path)

# Homebrew stores Rust target helpers such as `rust-objcopy` inside the sysroot.
# Put that directory on PATH when Rust is installed so native Neovim plugins can build.
if (( $+commands[rustc] )); then
  _rust_sysroot="$(rustc --print sysroot 2>/dev/null)"
  _rust_host="$(rustc -vV 2>/dev/null | awk '/^host: / { print $2 }')"
  if [[ -n "$_rust_sysroot" && -n "$_rust_host" && -d "$_rust_sysroot/lib/rustlib/$_rust_host/bin" ]]; then
    path=("$_rust_sysroot/lib/rustlib/$_rust_host/bin" $path)
  fi
  unset _rust_sysroot _rust_host
fi

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


# Added by Antigravity CLI installer
export PATH="/Users/nghiapm/.local/bin:$PATH"

# Unity CLI
if [[ -r "$HOME/.unity/env" ]]; then
  source "$HOME/.unity/env"
fi

# opencode
export PATH=/Users/nghiapm/.opencode/bin:$PATH

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/lap15874/.docker/completions $fpath)
autoload -Uz compinit
(( ${+_comps[docker]} )) || compinit
# End of Docker CLI completions

# Use the selected Docker context (Colima), including in shells that inherited
# the previous Podman socket from their parent process.
unset DOCKER_HOST


# Added by Antigravity CLI installer
export PATH="/Users/lap15874/.local/bin:$PATH"

# opencode
export PATH=/Users/lap15874/.opencode/bin:$PATH
