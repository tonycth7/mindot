# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
[[ -r /usr/share/bash-completion/bash_completion ]] && \
  source /usr/share/bash-completion/bash_completion

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=nvim
export PATH="$HOME/.local/bin:$PATH"  #Pass extra fuctions
#Aliases
[ -f ~/.aliases ] && source ~/.aliases

#BINDING

#PROMPT LOOK

#__git_branch() {
#  git rev-parse --is-inside-work-tree &>/dev/null || return
#  git branch --show-current 2>/dev/null | sed 's/^/  /'
#}
#__lang_hint() {
#  compgen -G build.zig     >/dev/null && { echo " ⚡"; return; }
#  compgen -G Cargo.toml   >/dev/null && { echo " 🦀"; return; }
#  compgen -G go.mod       >/dev/null && { echo " 🐹"; return; }
#  compgen -G "*.c" "*.h" "*.cpp" "*.hpp" "*.cc" "*.cxx" >/dev/null && { echo " ⚙"; return; }
#  compgen -G "*.s" "*.S" "*.asm" >/dev/null && { echo " 🧬"; return; }
#  compgen -G pyproject.toml requirements.txt >/dev/null && { echo " 🐍"; return; }
#  compgen -G package.json >/dev/null && { echo " ⬢"; return; }
#  compgen -G "*.sh" >/dev/null && echo " "
#}

#PS1=$'\[\e[36m\]┌[\[\e[97m\]\u \[\e[94m\]\w\[\e[35m\]$(__lang_hint)\[\e[33m\]$(__git_branch)\[\e[36m\]]\n└\[\e[97m\]❯ \[\e[0m\]'

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init bash)"
##
#HISTORY
# ───────────────────────────── History settings ───────────────────────────── #
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:erasedups
ROMPT_COMMAND='history -a; history -n'

# ───────────────────────────── fzf integration ────────────────────────────── #
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

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

# ✅ CORRECT binding
bind -x '"\C-r": __fzf_history'
##
eval "$(zoxide init bash)"
fastfetch
z
. "$HOME/.cargo/env"
