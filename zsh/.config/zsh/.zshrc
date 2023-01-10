#!/usr/bin/env zsh
#################################
# Start: Helpers
function src() {
    file=$1
    [ -f "$file" ] && source "$file" || echo "$file not exist. Abort sourcing"
}

[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh" || sh <(curl -s https://raw.githubusercontent.com/undg/zap/master/install.sh)
# End
#################################

#################################
# Start: Sources
src "/opt/asdf-vm/asdf.sh"
src "$ZDOTDIR/zconfig.zsh"
src "$ZDOTDIR/zpath.zsh"
src "$ZDOTDIR/zaliases.zsh"
src "$ZDOTDIR/secret.zsh"
# End
#################################

#################################
# Start: Plugins
plug "marlonrichert/zsh-autocomplete"
plug "zsh-users/zsh-completions"
plug "zsh-users/zsh-autosuggestions"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
plug "zsh-users/zsh-syntax-highlighting"
plug "zap-zsh/fzf"
plug "zsh-users/zsh-history-substring-search"
plug "hlissner/zsh-autopair"
plug "chrissicool/zsh-256color"
plug "undg/zsh-auto-notify"
plug "undg/zsh-autodotenv"
# End
#################################

#################################
# Start: Prompt
source <(/usr/bin/starship init zsh --print-full-init)
# End
#################################

#################################
# Start: Give some love to emacs
bindkey '^a' beginning-of-line  # ctrl+a go to start
bindkey '^e' end-of-line        # ctrl+e go to  end
bindkey '^H' backward-kill-word # instead ctrl+backspace
bindkey '^L' undo               # instead of ctrl+delete
bindkey '^K' redo               # instead of ctrl+delete
# End
#################################

#################################
# Start: edit command in vim
autoload -z edit-command-line
zle -N edit-command-line
bindkey '^ ' edit-command-line # ctrl+space: open command in vim
# End
#################################
