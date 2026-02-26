#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PAAS_HOME="$HOME/paas"

alias dw='z && ./dotfiles/Scripts/startx'
alias wall='feh --bg-fill ~/pictures/wallpaper.jpg'
alias ls='ls --color=auto'
alias la='ls -la'
alias grep='grep --color=auto'
alias vi='nvim'
alias vim='nvim'
PS1='[\u@\h \W]\$ '
eval "$(zoxide init bash)"
fastfetch
z
. "$HOME/.cargo/env"
export PATH=$PATH:~/statusbar
