#!/usr/bin/env zsh

#################################
# Start: Initialisation
#################################

# src
function src() {
	file=$1
	[ -f "$file" ] && source "$file" || $2 || echo "$file not exist."
}

# plug
if [[ -f "$HOME/.local/share/zap/zap.zsh" ]]; then
	source "$HOME/.local/share/zap/zap.zsh"
else
	sh <(curl -s https://raw.githubusercontent.com/undg/zap/master/install.sh) # install
fi

#################################
# To suppress p10k warning about console output.
# Run them before p10k. Those guys should produce stdout's.
#################################

# Print a static or dynamic, hopefully interesting, adage.
# First "if installed" win [fortune(and cowsay), neofetch, archey3]

if (( $+commands[fortune] )); then
	if (( $+commands[cowsay] )); then
		fortune definitions|cowsay
		print
	else
		fortune -s
		print
	fi
elif (( $+commands[neofetch] )); then
	archey3 -c red
	print
elif (( $+commands[archey3] )); then
	archey3 -c red
	print
fi

# auto source .env file in project folder.
plug "undg/zsh-autodotenv"

#################################
# Powerlevel10k
#################################

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# This file is git ignored but sourced
touch -a "$ZDOTDIR/private.zsh"


#################################
# Start: Sources and Plugins
#################################
src "$ZDOTDIR/config.zsh"
# @TODO (undg) 2023-02-19: moved to zprofile to run on login. Test and delete.
# src "$ZDOTDIR/path.zsh"
src "$ZDOTDIR/aliases.zsh"
src "$ZDOTDIR/private.zsh" # file in gitignore
# src "/opt/asdf-vm/asdf.sh" # lang version manager/installer
eval "$(/bin/rtx activate zsh)" # lang version manager/installer
eval "$(fasd --init auto)" # autojump aliased to z and j(aliases)
plug "chrissicool/zsh-256color"
plug "hlissner/zsh-autopair" # auto closing ()[]{}''"" etc.
plug "undg/zsh-auto-notify" # system notification for long running processes

plug "romkatv/powerlevel10k" # powerlevel10k prompt
src ~/.config/zsh/p10k.zsh

src "$ZDOTDIR/completion.zsh"
plug "zsh-users/zsh-completions" # hand written by community suggestion files for many packages

plug "zsh-users/zsh-autosuggestions" # fish like suggestion
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

plug "zsh-users/zsh-syntax-highlighting"
# fix invisible strings that starts with # or $
# https://github.com/zsh-users/zsh-syntax-highlighting/issues/510
ZSH_HIGHLIGHT_STYLES[comment]='none'

plug "zap-zsh/fzf" # famous fuzzy finder

plug "zsh-users/zsh-history-substring-search"
bindkey '^[[A' history-substring-search-up # arrow up
bindkey '^[[B' history-substring-search-down # arrow down


#################################
# Start: key mappings
#################################
bindkey '^a' beginning-of-line # Give some love to emacs
bindkey '^e' end-of-line # Give some love to emacs

bindkey '^h' backward-kill-word
bindkey '^j' backward-word
bindkey '^k' forward-word
bindkey '^l' undo
bindkey '^o' redo

bindkey "\e[3~" delete-char # fix delete key
bindkey "^?" backward-delete-char # fix backspace after normal mode

exit_zsh() { exit }
zle -N exit_zsh
bindkey "^[q" exit_zsh

#################################
# Start: edit command in vim
#################################
autoload -z edit-command-line
zle -N edit-command-line
bindkey '^ ' edit-command-line # ctrl+space: open command in vim

