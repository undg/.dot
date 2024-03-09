#!/usr/bin/env zsh

# This zshrc is using simple zap plugin manager. `zap --help` for more details.
# Code that is not imported from plugins repositories, is simply sourced.

#################################
# Start: Profiling
# Set profiling to 
# 0 - off
# 1 - produce /tmp/startuplog.*_functions
# 2 - produce above and more detailed /tmp/startlog.*_commands
#################################
PROFILING_LEVEL=0

# Based on: https://stackoverflow.com/a/4351664/2103996

if (( PROFILING_LEVEL > 0 )); then
	if (( PROFILING_LEVEL > 1 )); then
		# Per-command profiling:
		zmodload zsh/datetime
		setopt promptsubst
		PS4='+$EPOCHREALTIME %N:%i> '
		exec 3>&2 2> /tmp/startlog.$$.$(date +%Y-%m-%d_%H-%M-%S)_commands
		setopt xtrace prompt_subst

	fi
	# Per-function profiling:
	zmodload zsh/zprof
fi
	zmodload zsh/zprof

#################################
# Start: Initialisation
#################################

# src
local function src_local() {
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
touch -a "$ZDOTDIR/secret.zsh"


#################################
# Sources and Plugins
#################################
src_local "$ZDOTDIR/secret.zsh" # file in gitignore
# auto source .env file in project folder.
plug "undg/zsh-autodotenv"
src_local "$ZDOTDIR/config.zsh"
src_local "$ZDOTDIR/aliases.zsh"
eval "$(/bin/mise activate zsh)" # lang version manager/installer
eval "$(fasd --init auto)" # autojump aliased to z and j(aliases)

# plug "chrissicool/zsh-256color"
plug "hlissner/zsh-autopair" # auto closing ()[]{}''"" etc.
plug "undg/zsh-auto-notify" # system notification for long running processes

plug "romkatv/powerlevel10k" # powerlevel10k prompt
src_local ~/.config/zsh/p10k.zsh

src_local "$ZDOTDIR/completion.zsh"
plug "zsh-users/zsh-completions" # hand written by community suggestion files for many packages

plug "zsh-users/zsh-autosuggestions" # fish like suggestion
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

plug "zsh-users/zsh-syntax-highlighting"
# fix invisible strings that starts with # or $
# https://github.com/zsh-users/zsh-syntax-highlighting/issues/510
ZSH_HIGHLIGHT_STYLES[comment]='none'

# This overrides ^R and arrow-up
# export ATUIN_NOBIND="true"
# eval "$(atuin init zsh)" # better shell history
# bindkey '^r' atuin-search
# bindkey '^R' atuin-up-search

# export ATUIN_NOBIND="true"
eval "$(atuin init zsh --disable-up-arrow)"

# autoload -U atuin-search 
# zle -N atuin-search 
bindkey '^f' atuin-search

#################################
# key mappings
#################################
set -o emacs 

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

# https://unix.stackexchange.com/a/79905
# same bind-key is set in tmux
bindkey -s '^g' '^utmux-sessionizer^M'

# @TODO (undg) 2024-03-07: detete after testing period
# ---- replaced with `atuin`
# plug "zap-zsh/fzf" # famous fuzzy finder
# ---- replaced with `atuin`
# replace "zsh-users/zsh-history-substring-search" with native solution
# https://unix.stackexchange.com/a/672892
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Arrow up
bindkey "^[[B" down-line-or-beginning-search # Arrow down


#################################
# edit command in vim
#################################
autoload -z edit-command-line
zle -N edit-command-line
bindkey '^ ' edit-command-line # ctrl+space: open command in vim


#################################
# Profiling
#################################
if (( PROFILING_LEVEL > 0 )); then
	if (( PROFILING_LEVEL > 1 )); then
		# Per-command profiling:
		unsetopt xtrace
		exec 2>&3 3>&-
	fi

	# Per-function profiling:
	zprof > /tmp/startlog.$$.$(date +%Y-%m-%d_%H-%M-%S)_functions
fi
