#!/usr/bin/env zsh

# export NPM_PACKAGES="${HOME}/npm-packages"
# Unset manpath so we can inherit from /etc/manpath via the `manpath`
# command
# unset MANPATH # delete if you already modified MANPATH elsewhere in your config
# export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.deno/bin:$PATH"
export PATH="$PATH:$(go env GOBIN):$(go env GOPATH)/bin"

# Adds `~/.config/i3/scripts` and all subdirectories to $PATH
if [[ -d "$HOME/.config/i3/scripts/" ]]; then
    export PATH="$(du "$HOME/.config/i3/scripts/" | cut -f2 | tr '\n' ':')$PATH"
fi

# debloate WSL from m$ windows paths (fix lagging in terminal)
export PATH=$(/usr/bin/printenv PATH | /usr/bin/perl -ne 'print join(":", grep { !/\/mnt\/[a-z]/ } split(/:/));')
