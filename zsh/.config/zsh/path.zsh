#!/usr/bin/env zsh

# exports
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.deno/bin:$PATH"


# @TODO (undg) 2023-01-01: check that nonsens
# leftover from larbs
# Set the list of directories that Zsh searches for programs.
path=(
    /usr/local/{bin,sbin}
    $HOME/.config/i3/scripts/
    # $HOME/bin
    $path
)

export PATH=$(/usr/bin/printenv PATH | /usr/bin/perl -ne 'print join(":", grep { !/\/mnt\/[a-z]/ } split(/:/));')
# Adds `~/.config/i3/scripts` and all subdirectories to $PATH
if [[ -d "$HOME/.config/i3/scripts/" ]]; then
    export PATH="$(du "$HOME/.config/i3/scripts/" | cut -f2 | tr '\n' ':')$PATH"
fi
