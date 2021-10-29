# vim: ts=2 sw=2
#
# Useless comment with useless stuff
#

# export TERM="screen-256color"
# export TERM="xterm-256color"
export VISUAL=nvim
export VEDITOR="$VISUAL"
export LD_LIBRARY_PATH=$HOME/lib/:$LD_LIBRARY_PATH

export NPM_PACKAGES="${HOME}/npm-packages"
# Unset manpath so we can inherit from /etc/manpath via the `manpath`
# command
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

# export PATH=$HOME/bin:$PATH
# export PATH="$NPM_PACKAGES/bin:$PATH"
if [[ -d "$HOME/.local/bin/" ]]; then
    export PATH="$(du "$HOME/.local/bin/" | cut -f2 | tr '\n' ':')$PATH"
fi
if [[ -d "$HOME/.deno/bin/" ]]; then
    export PATH="$HOME/.deno/bin:$PATH"
fi
if [[ -f ~/.customprofile ]]; then
    source "$HOME/.customprofile"
fi


# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
    source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
if [[ -s "${ZDOTDIR:-$HOME}/.zaliases" ]]; then
    source "${ZDOTDIR:-$HOME}/.zaliases"
fi

unsetopt correct_all
unsetopt correct

# Real VI experience in CLI ;-D
bindkey -v
autoload -z edit-command-line
zle -N edit-command-line
bindkey -M vicmd ' ' edit-command-line

# Give some love to emacs
bindkey '^H' backward-kill-word # ctrl + backspace
bindkey '^r' history-incremental-search-backward
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# Better history with arrow up and down
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# # TODO: after switching prompt to `pure` this is not needed. Delete it if prompt will stay. I'm not 100% sure about precmd() and keytimeout. <21-10-21> #
# precmd() { RPROMPT="" }
# function zle-keymap-select {
#   VIM_PROMPT="[% NORMAL]%"
#   RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
#   zle reset-prompt
# }

# zle -N zle-keymap-select

# export KEYTIMEOUT=1



# (FIX) CURSOR DISAPPEARS WHEN MOVING BACK
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[cursor]=underline

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Now nvm, node, yarn and npm are loaded on their first invocation, posing no start up time penalty for the shells that aren’t going to use them at all.
load-nvm() {
    export NVM_DIR=~/.nvm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
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

