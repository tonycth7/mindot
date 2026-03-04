
[[ -f ~/.aliases ]] && source ~/.aliases

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

eval "$(starship init zsh)"

eval "$(zoxide init zsh)"
fastfetch
