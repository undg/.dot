#!/bin/bash
# Profile file. Runs on login.

# Set the list of directories that Zsh searches for programs.
path=(
    /usr/local/{bin,sbin}
    ~/bin
    ~/.zprezto/bin
    $path
)
export PATH=$(/usr/bin/printenv PATH | /usr/bin/perl -ne 'print join(":", grep { !/\/mnt\/[a-z]/ } split(/:/));')
# Adds `~/.config/i3/scripts` and all subdirectories to $PATH
if [[ -d "$HOME/.config/i3/scripts/" ]]; then
    export PATH="$(du "$HOME/.config/i3/scripts/" | cut -f2 | tr '\n' ':')$PATH"
fi
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="brave"
export BRAVE="brave"
export CHROME="chromium"
export READER="zathura"
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

if [[ -f ~/.zshrc ]]; then
    source "$HOME/.zshrc"
fi

# Speedy keys delay/repeatSpeed
xset r rate 222 40

# Volume applet in sys tray
# volctl &

# Start graphical server if i3 not already running.
[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x i3 >/dev/null && exec startx

