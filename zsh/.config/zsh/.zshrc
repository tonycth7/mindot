# ---------- PATH ----------
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# ---------- STARSHIP ----------
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

# ---------- ZOXIDE ----------
eval "$(zoxide init zsh)"

# ---------- FASTFETCH ----------
fastfetch

# ---------- ZINIT INSTALL ----------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

source "${ZINIT_HOME}/zinit.zsh"

# ---------- PLUGINS ----------

# autosuggestions (like fish)
zinit light zsh-users/zsh-autosuggestions

# syntax highlighting
zinit light zsh-users/zsh-syntax-highlighting

# history substring search (arrow key search)
zinit light zsh-users/zsh-history-substring-search

# better completions
zinit light zsh-users/zsh-completions

# ---------- COMPLETION SYSTEM ----------
autoload -Uz compinit
compinit

# ---------- KEYBINDINGS ----------

# history search with arrows
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# autosuggest accept with ctrl+space
bindkey '^ ' autosuggest-accept

# ---------- ALIASES ----------
[ -f ~/.aliases ] && source ~/.aliases
