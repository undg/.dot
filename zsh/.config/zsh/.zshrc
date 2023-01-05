#!/usr/bin/env zsh
#################################
# Start: Helpers
function src() {
    file=$1
    [ -f "$file" ] && source "$file" || echo "$file not exist. Abort sourcing"
}

# End
#################################

src "$ZDOTDIR/zconfig.zsh" 

#################################
# Start: Plugins
# src "$HOME/.local/share/zap/zap.zsh" # zap plugin manager
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh" || echo "$HOME/.local/share/zap/zap.zsh not exist. Abort sourcing"

# plug "marlonrichert/zsh-autocomplete"
plug "zsh-users/zsh-completions"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "zap-zsh/fzf"
plug "zsh-users/zsh-history-substring-search"
plug "hlissner/zsh-autopair"
# plug "chrissicool/zsh-256color"
plug "undg/zsh-nvm-lazy-load"
plug "undg/zsh-auto-notify"
plug "undg/zsh-autodotenv"
plug "undg/zsh-z"
# End
#################################

#################################
# Start: Sources
# src "/opt/asdf-vm/asdf.sh" 
src "$ZDOTDIR/zaliases.zsh" 
src "$ZDOTDIR/secret.zsh" 
# End
#################################

#################################
# Start: Prompt
source <(/usr/bin/starship init zsh --print-full-init)
# End
#################################

#################################
# Start: Better history with arrow up, down and ?
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search # Up arrow
bindkey '^K' up-line-or-beginning-search       # ctrl+k up

bindkey "^[[B" down-line-or-beginning-search # Down arrow
bindkey '^J' down-line-or-beginning-search    # ctrl+j down
# End
#################################

#################################
# Start: Navigation in autocompletion menu
bindkey -M menuselect '?' history-incremental-search-forward # search
bindkey -M menuselect '^[[Z' reverse-menu-complete           # shift-tab (why it's not default?)

bindkey -M menuselect '^J' vi-down-line-or-history           # ctrl+j down
bindkey -M menuselect '^K' vi-up-line-or-history             # ctrl+k up
bindkey -M menuselect '^L' vi-forward-char                   # ctrl+l right
bindkey -M menuselect '^H' vi-backward-char                  # ctrl+h left
# End
#################################

#################################
# Start: Give some love to emacs
bindkey '^a' beginning-of-line  # ctrl+a go to start
bindkey '^e' end-of-line        # ctrl+e go to  end
bindkey '^H' backward-kill-word # instead ctrl+backspace
bindkey '^L' kill-word          # instead of ctrl+delete
bindkey '^[[3;5~' undo          # this is ctrl+delete
# End
#################################

#################################
# Start: edit command in vim
autoload -z edit-command-line
zle -N edit-command-line
bindkey '^ ' edit-command-line # ctrl+space: open command in vim
# End
#################################

