###############################################################################
# Core aliases
###############################################################################

alias vi="nvim"
alias vim="nvim"
alias lg="lazygit"

alias ls="ls --color=auto"
alias grep="grep --color=auto"

###############################################################################
# Safer defaults
###############################################################################

alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -iv"
alias mkdir="mkdir -pv"

###############################################################################
# Modern replacements
###############################################################################

# ripgrep
alias rg="rg --smart-case --hidden --follow"
alias rgi="rg --ignore-case"
alias rgf="rg --files"

# fd
alias fd="fd --hidden --follow --exclude .git"
alias fdd="fd --type d"
alias fdf="fd --type f"

# eza
alias l="eza --icons --group-directories-first"
alias ll="eza -lah --icons --group-directories-first"
alias la="eza -ah --icons --group-directories-first"
alias lt="eza --tree --icons"
alias lf="eza -fa --icons"
alias ld="eza -Da --icons"

# bat
alias cat="bat --style=plain"
alias batp="bat --paging=always"
alias bath="bat --style=header,grid"

###############################################################################
# Pager
###############################################################################

set -gx LESS "-R --use-color -F -X"

###############################################################################
# fzf-powered workflows
###############################################################################

# Open file in nvim
function vf
    set file (fd --type f | fzf --preview 'bat --style=numbers --color=always {}')
    if test -n "$file"
        nvim "$file"
    end
end

# Search code and open
function vgl
    set file (rg --files-with-matches . | \
        fzf --preview 'bat --style=numbers --color=always {}')
    if test -n "$file"
        nvim "$file"
    end
end

# cd using fzf
function cdf
    set dir (fd --type d | fzf)
    if test -n "$dir"
        cd "$dir"
    end
end

# zoxide jump
function zf
    set dir (zoxide query -l | fzf)
    if test -n "$dir"
        cd "$dir"
    end
end

# Edit OR cd smart
function ve
    set target (fd | \
        fzf --preview 'if test -d {}; eza -T --icons {}; else; bat --style=numbers --color=always {}; end')

    if test -n "$target"
        if test -d "$target"
            cd "$target"
        else
            nvim "$target"
        end
    end
end

###############################################################################
# Git helpers
###############################################################################

function gco
    set branch (git branch --all --color=always | \
        sed 's/^[* ] //' | \
        fzf --preview 'git log --oneline --decorate --color=always {}')

    if test -n "$branch"
        git checkout (string replace -r '.*/' '' $branch)
    end
end

###############################################################################
# QoL helpers
###############################################################################

alias cls="clear"
alias duh="du -h --max-depth=1"

function path
    printf "%s\n" $PATH
end

alias reload="exec fish"
