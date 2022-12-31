# The new re-$HOME-ing variable
: ${XDG_CONFIG_HOME:=$HOME/.config}

# ZDOTDIR is a zsh-ism (natively supported)...
# but it's a really cool concept.
# Zsh use the parameter name ZDOTDIR when looking
# for core start-up files, defaulting to $HOME if it's not set.
ZDOTDIR=$XDG_CONFIG_HOME/zsh

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

