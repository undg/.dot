#!/bin/bash
# Profile file. Runs on login.


#################
# Start: old zsh artefacts
export GPG_TTY=$(tty)
export VISUAL=nvim
export VEDITOR="$VISUAL"
export LD_LIBRARY_PATH=$HOME/lib/:$LD_LIBRARY_PATH

# export NPM_PACKAGES="${HOME}/npm-packages"
# Unset manpath so we can inherit from /etc/manpath via the `manpath`
# command
# unset MANPATH # delete if you already modified MANPATH elsewhere in your config
# export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

# export PATH=$HOME/bin:$PATH
# export PATH="$NPM_PACKAGES/bin:$PATH"
    # export PATH="$HOME/.deno/bin:$PATH"
# End: old zsh artefacts
#################

# Set the list of directories that Zsh searches for programs.
# path=(
#     /usr/local/{bin,sbin}
#     $path
# )

# @TODO (undg) 2023-01-01: check that nonsens
export PATH=$(/usr/bin/printenv PATH | /usr/bin/perl -ne 'print join(":", grep { !/\/mnt\/[a-z]/ } split(/:/));')
# Adds `~/.config/i3/scripts` and all subdirectories to $PATH
if [[ -d "$HOME/.config/i3/scripts/" ]]; then
    export PATH="$(du "$HOME/.config/i3/scripts/" | cut -f2 | tr '\n' ':')$PATH"
fi

export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="brave"
export CHROME="chromium"
export READER="xreader"

# less/man colors
export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# Start graphical server if i3 not already running.
[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x i3 >/dev/null && exec startx

