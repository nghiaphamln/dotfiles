# Interactive Zsh configuration.

# Smarter `cd` powered by directory history.
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

# Gruvbox prompt managed by Oh My Posh.
_omp_config="$HOME/.config/oh-my-posh/gruvbox.omp.json"
if (( $+commands[oh-my-posh] )) && [[ -r "$_omp_config" ]]; then
  eval "$(oh-my-posh init zsh --config "$_omp_config")"
fi
unset _omp_config
