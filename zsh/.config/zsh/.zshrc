#!/usr/bin/env zsh
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh" || echo 'file not found'

plug "zsh-users/zsh-completions"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "zap-zsh/fzf"
plug "zsh-users/zsh-history-substring-search"
plug "hlissner/zsh-autopair"
plug "chrissicool/zsh-256color"

plug "undg/zsh-nvm-lazy-load"
plug "undg/zsh-supercharge"
plug "undg/zsh-auto-notify"
plug "undg/zsh-autodotenv"

[ -f "$ZDOTDIR/zaliases.zsh" ] && source "$ZDOTDIR/zaliases.zsh" || echo 'file zaliases not found'

#################################
# Start: Prompt
source <(/usr/bin/starship init zsh --print-full-init)
# End: Prompt
#################################

#################################
# Start: Better history with arrow up, down and ?
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up arrow
bindkey '^K' up-line-or-beginning-search

autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search # Down arrow
bindkey '^J' down-line-or-beginning-search

bindkey -M menuselect '?' history-incremental-search-forward
# Edn: Better history with arrow up, down and ?
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

[ -f "$ZDOTDIR/secret.zsh" ] && source "$ZDOTDIR/secret.zsh"
