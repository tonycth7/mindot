#
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

alias dw='z && ./dotfiles/Scripts/startx'
alias wall='feh --bg-fill ~/pictures/wallpaper.jpg'
alias ls='ls --color=auto'
alias la='ls -la'
alias grep='grep --color=auto'
alias vi='nvim'
alias vim='nvim'
alias lg='lazygit'
##
#BINDING
# fzf key bindings (completion + history)
if [ -f /usr/share/fzf/key-bindings.bash ]; then
  source /usr/share/fzf/key-bindings.bash
fi

if [ -f /usr/share/fzf/completion.bash ]; then
  source /usr/share/fzf/completion.bash
fi

#PROMPT LOOK

__git_branch() {
  git rev-parse --is-inside-work-tree &>/dev/null || return
  git branch --show-current 2>/dev/null | sed 's/^/  /'
}
__lang_hint() {
  compgen -G build.zig     >/dev/null && { echo " ⚡"; return; }
  compgen -G Cargo.toml   >/dev/null && { echo " 🦀"; return; }
  compgen -G go.mod       >/dev/null && { echo " 🐹"; return; }
  compgen -G "*.c" "*.h" "*.cpp" "*.hpp" "*.cc" "*.cxx" >/dev/null && { echo " ⚙"; return; }
  compgen -G "*.s" "*.S" "*.asm" >/dev/null && { echo " 🧬"; return; }
  compgen -G pyproject.toml requirements.txt >/dev/null && { echo " 🐍"; return; }
  compgen -G package.json >/dev/null && { echo " ⬢"; return; }
  compgen -G "*.sh" >/dev/null && echo " "
}

PS1=$'\[\e[36m\]┌[\[\e[97m\]\u \[\e[94m\]\w\[\e[35m\]$(__lang_hint)\[\e[33m\]$(__git_branch)\[\e[36m\]]\n└\[\e[97m\]› \[\e[0m\]'

##
#HISTORY
# History behavior
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:erasedups
PROMPT_COMMAND="history -a; history -c; history -r"
# fzf history search
__fzf_history() {
  history | sed 's/ *[0-9]* *//' | fzf --height=40% --reverse
}

bind -x '"\C-r": "__fzf_history"'
##
eval "$(zoxide init bash)"
fastfetch
z
. "$HOME/.cargo/env"
