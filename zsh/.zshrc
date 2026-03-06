###############################################################################
# Tony's Clean ZSH Setup
###############################################################################

############################
# XDG PATHS
############################

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

############################
# ZINIT INSTALL
############################

ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME/.git" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

############################
# COMPLETION SYSTEM
############################

autoload -Uz compinit
compinit

############################
# PLUGINS
############################

# fish-like autosuggestions
zinit light zsh-users/zsh-autosuggestions

# fast syntax highlighting
zinit light zdharma-continuum/fast-syntax-highlighting

# history substring search
zinit light zsh-users/zsh-history-substring-search

# extra completions
zinit light zsh-users/zsh-completions

# fuzzy interactive tab completion
zinit light Aloxaf/fzf-tab

############################
# STARSHIP PROMPT
############################

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

############################
# ZOXIDE (smart cd)
############################

eval "$(zoxide init zsh)"

############################
# FZF INTEGRATION
############################

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

export FZF_DEFAULT_OPTS="\
--height=45% \
--layout=reverse \
--border \
--inline-info \
--preview-window=right:60%"

############################
# FZF + FD SPEED BOOST
############################

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

############################
# FZF PREVIEW SETTINGS
############################

export FZF_CTRL_T_OPTS="
--preview 'bat --color=always --style=numbers {}'
"

export FZF_ALT_C_OPTS="
--preview 'eza --tree --level=2 --icons --color=always {}'
"

############################
# FZF-TAB SETTINGS
############################

zstyle ':fzf-tab:*' switch-group ',' '.'

zstyle ':fzf-tab:*' fzf-flags \
--height=50% \
--layout=reverse \
--border \
--inline-info

# preview directories / files
zstyle ':fzf-tab:complete:*' fzf-preview '
if [ -d $realpath ]; then
  eza --tree --level=2 --icons --color=always $realpath
else
  bat --color=always --style=numbers $realpath
fi
'

############################
# BETTER COMPLETION
############################

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

############################
# HISTORY SETTINGS
############################

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt inc_append_history
setopt extended_history

############################
# KEYBINDINGS
############################

# history substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# accept autosuggestion
bindkey '^ ' autosuggest-accept

############################
# PATH IMPROVEMENTS
############################

export PATH="$HOME/.local/bin:$PATH"

############################
# SOURCE ALIASES
############################

[ -f ~/.aliases ] && source ~/.aliases

############################
# FASTFETCH
############################

fastfetch
