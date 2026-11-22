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

# Unity CLI
if [[ -r "$HOME/.unity/env" ]]; then
  source "$HOME/.unity/env"
fi

# OpenCode and Flutter installed in the user's home directory.
if [[ -d "$HOME/.opencode/bin" ]]; then
  path=("$HOME/.opencode/bin" $path)
fi
if [[ -d "$HOME/development/flutter/bin" ]]; then
  path+=("$HOME/development/flutter/bin")
fi

# Fall back to full Xcode when xcode-select only points to Command Line Tools.
if [[ -z ${DEVELOPER_DIR:-} && -d /Applications/Xcode.app/Contents/Developer &&
      $(xcode-select -p 2>/dev/null) != */Contents/Developer ]]; then
  export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
fi

# Docker Desktop installs its completions here.
if [[ -d "$HOME/.docker/completions" ]]; then
  typeset -U fpath
  fpath=("$HOME/.docker/completions" $fpath)
  autoload -Uz compinit
  (( ${+_comps[docker]} )) || compinit
fi

# Let the selected Colima context take over from a stale Podman socket.
if [[ ${DOCKER_HOST:-} == unix://*/podman/*.sock && ! -S "${DOCKER_HOST#unix://}" ]] &&
   (( $+commands[docker] )) &&
   [[ $(env -u DOCKER_HOST docker context show 2>/dev/null) == colima(|-*) ]]; then
  unset DOCKER_HOST
fi
