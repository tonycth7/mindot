###############################################################################
# Tony's Bash Setup (Modern CLI)
###############################################################################

# Exit if not interactive
[[ $- != *i* ]] && return

###############################################################################
# Bash completion
###############################################################################

if [[ -r /usr/share/bash-completion/bash_completion ]]; then
  source /usr/share/bash-completion/bash_completion
fi

###############################################################################
# Environment
###############################################################################

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=nvim
export PATH="$HOME/.local/bin:$PATH"

###############################################################################
# Source aliases
###############################################################################

[ -f ~/.aliases ] && source ~/.aliases

###############################################################################
# HISTORY SETTINGS
###############################################################################

shopt -s histappend

HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:erasedups

# realtime history sync between terminals
PROMPT_COMMAND='history -a; history -n'

###############################################################################
# FZF + FD SEARCH
###############################################################################

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_DEFAULT_OPTS="
--height 45%
--layout=reverse
--border
--info=inline
"
fzf-cd-widget() {
  local dir
  dir=$(
    fd --type d --hidden --exclude .git |
    fzf --height 40% --reverse --border \
        --preview 'eza --tree --level=2 --icons {}'
  ) || return
  cd "$dir"
}

bind -x '"\ec": fzf-cd-widget'
###############################################################################
# FZF KEYBINDINGS + COMPLETION
###############################################################################

[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash

###############################################################################
# FZF HISTORY SEARCH (better CTRL+R)
###############################################################################

__fzf_history() {
  local selected
  selected=$(
    history |
      sed 's/^[ ]*[0-9]\+[ ]*//' |
      tac |
      fzf --height=40% --reverse --prompt='History > '
  ) || return

  READLINE_LINE="$selected"
  READLINE_POINT=${#READLINE_LINE}
}

bind -x '"\C-r": __fzf_history'

###############################################################################
# ZOXIDE (SMART CD)
###############################################################################

eval "$(zoxide init bash)"

###############################################################################
# STARSHIP PROMPT
###############################################################################

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init bash)"

###############################################################################
# RUST CARGO ENV
###############################################################################

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

###############################################################################
# STARTUP PROGRAMS
###############################################################################

command -v fastfetch >/dev/null && fastfetch

###############################################################################
# SHORTCUTS
###############################################################################

