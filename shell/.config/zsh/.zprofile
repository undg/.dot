#!/bin/zsh
# Profile file. Runs on login.

source ~/.config/zsh/path.zsh

#################
# Start: old zsh artefacts
export GPG_TTY=$(tty)
export VISUAL=nvim
export EDITOR="$VISUAL"
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

RETARDED_OS=$([[ "$(uname)" == "Darwin" ]] && [[ "$(hostname)" =~ \.mhf\.mhc$ ]] && echo true || echo false)

if [[ "$RETARDED_OS" == "true" ]]; then
	export BROWSER="open"
fi

export ANDROID_SDK_ROOT=~/Android/Sdk
export ANDROID_HOME=~/Android/Sdk

# Quick fix for Handy
# https://github.com/cjpais/Handy/issues/114#issuecomment-3357408907
export LD_PRELOAD="/lib64/libwayland-client.so.0"

# Override GPU architecture version for HSA (Heterogeneous System Architecture) - needed for AMD ROCm compatibility
# export HSA_OVERRIDE_GFX_VERSION=10.3.0

if [[ "$(hostname)" == "cm" ]]; then
	export SCREEN_LEFT="DisplayPort-1"
	export SCREEN_TOP="HDMI-A-0"
	export SCREEN_RIGHT="DisplayPort-0"
elif [[ "$(hostname)" == "di-7415" ]]; then
	export SCREEN_LEFT="HDMI-A-0" # TOP in work
	export SCREEN_TOP="HDMI-A-0"  # TOP in work
	export SCREEN_RIGHT="eDP"     # BOTTOM in work
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

if [[ "$(uname)" == "Linux" ]]; then
	# Start graphical server if i3 not already running.
	[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x i3 >/dev/null && exec startx
fi

if [[ "$(uname)" == "Darwin" ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi
