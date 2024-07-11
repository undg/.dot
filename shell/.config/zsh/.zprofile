#!/bin/bash
# Profile file. Runs on login.

source ~/.config/zsh/path.zsh

#################
# Start: old zsh artefacts
export GPG_TTY=$(tty)
export VISUAL=nvim
export VEDITOR="$VISUAL"
export LD_LIBRARY_PATH=$HOME/lib/:$LD_LIBRARY_PATH

# End: old zsh artefacts
#################


# Some of those variables are used in ~/.config/i3/config

export EDITOR="nvim"
export TERMINAL="alacritty"
# export TERMINAL="kitty"
export BROWSER="brave"
export CHROME="chromium"
export READER="xreader"

if [[ "$(hostname)" == "cm" ]]; then
  export SCREEN_LEFT="DisplayPort-1"
  export SCREEN_RIGHT="DisplayPort-0"
  export SCREEN_TOP="HDMI-A-0"
elif [[ "$(hostname)" == "di-7415" ]]; then
  export SCREEN_LEFT="eDP"       # BOTTOM in work
  export SCREEN_RIGHT="HDMI-A-0" # TOP in work
  export SCREEN_TOP="HDMI-A-0"   # TOP in work
fi

# less/man colors
export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline


export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_PLATFORMTHEME="qt5ct"
export QT_PLATFORM_PLUGIN="qt5ct"
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCALE_FACTOR=1

export GTK_THEME=Adwaita:dark

# Start graphical server if i3 not already running.
[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x i3 >/dev/null && exec startx
