if status is-interactive


  # Commands to run in interactive sessions can go here

## ALIASES 
source ~/.config/fish/aliases.fish
# ~/.config/fish/config.fish
set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
starship init fish | source
zoxide init fish | source

fastfetch
end
