#!/usr/bin/env zsh
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh" || echo 'file not found'

plug "zap-zsh/supercharge"
plug "zsh-users/zsh-completions"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "zap-zsh/fzf"
plug "zsh-users/zsh-history-substring-search"
plug "zap-zsh/supercharge"
plug "zap-zsh/exa"

[ -f "$ZDOTDIR/zaliases.zsh" ] && source "$ZDOTDIR/zaliases.zsh" || echo 'file zaliases not found'

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

source <(/usr/bin/starship init zsh --print-full-init)

# @TODO (undg) 2022-12-31: move below blocks to plugins

#################################
# Start: nvm lazy loading
# Now nvm, node, yarn and npm are loaded on their first invocation, posing no start up time penalty for the shells that aren’t going to use them at all.
load-nvm() {
    export NVM_DIR=~/.nvm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
}

nvm() {
    unset -f nvm
    load-nvm
    nvm "$@"
}

node() {
    unset -f node
    load-nvm
    node "$@"
}

npm() {
    unset -f npm
    load-nvm
    npm "$@"
}

yarn() {
    unset -f yarn
    load-nvm
    yarn "$@"
}
# End: nvm lazy loader
#################################

#################################
# Start: Better history with arrow up and down
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up arrow
bindkey '^K' up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search # Down arrow
bindkey '^J' down-line-or-beginning-search
# Edn: Better history with arrow up and down
#################################

#################################
# Start: Give some love to emacs
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^H' backward-kill-word # instead ctrl + backspace
bindkey '^L' kill-word          # instead of ctrl + delete
bindkey '^[[3;5~' undo          # this is ctrl+delete
# End: Give some love to emacs
#################################

#################################
# Start: edit command in vim
# bindkey '^r' history-incremental-search-backward
autoload -z edit-command-line
zle -N edit-command-line
bindkey '^ ' edit-command-line # ctrl+space: open command in vim
# End:  edit command in vim
#################################
