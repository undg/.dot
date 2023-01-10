#!/usr/bin/env zsh
#################################
# Start: Initialisation

# src
function src() {
    file=$1
    [ -f "$file" ] && source "$file" || echo "$file not exist."
}

# plug
if [[ -f "$HOME/.local/share/zap/zap.zsh" ]]; then
    source "$HOME/.local/share/zap/zap.zsh"
else
    sh <(curl -s https://raw.githubusercontent.com/undg/zap/master/install.sh) # install
fi

# git ignored but sourced
touch -a "$ZDOTDIR/private.zsh"

# End
#################################

#################################
# Start: Sources
src "$ZDOTDIR/config.zsh"
src "$ZDOTDIR/path.zsh"
src "$ZDOTDIR/aliases.zsh"
src "$ZDOTDIR/private.zsh"
src "/opt/asdf-vm/asdf.sh"
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
