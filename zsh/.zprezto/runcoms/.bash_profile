#!/bin/bash
# Profile file. Runs on login.

# Set the list of directories that Zsh searches for programs.
path=(
  /usr/local/{bin,sbin}
  ~/bin
  ~/.zprezto/bin
  $path
)

# Adds `~/.config/i3/scripts` and all subdirectories to $PATH
export PATH="$(du "$HOME/.config/i3/scripts/" | cut -f2 | tr '\n' ':')$PATH"
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="chromium"
export READER="zathura"
export BIB="$HOME/Documents/LaTeX/uni.bib"
export REFER="$HOME/.referbib"
# PIX is here I have LARBS keep icons. Subject to change, hence a variable.
export PIX="$HOME/.config/i3/scripts/pix"
export SUDO_ASKPASS="$HOME/.config/i3/scripts/tools/dmenupass"

# less/man colors
export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

[ ! -f ~/.shortcuts ] && shortcuts >/dev/null 2>&1

if [[ -f ~/.zshrc ]]; then
  source "$HOME/.zshrc"
elif [[ -f ~/.bashrc ]]; then
  source "$HOME/.bashrc"
fi

# Start graphical server if i3 not already running.
[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x i3 >/dev/null && exec startx

# Switch escape and caps and use wal colors if tty:
sudo -n loadkeys ~/.config/i3/scripts/ttymaps.kmap 2>/dev/null
