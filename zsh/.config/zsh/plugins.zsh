#!/usr/bin/env zsh

[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh" || echo 'file not found'


# Example install plugins
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "zap-zsh/fzf"
plug "zsh-users/zsh-history-substring-search"


# Example theme
# plug "zap-zsh/zap-prompt"
plug "zap-zsh/atmachine-prompt"

# Example install completion
# plug "esc/conda-zsh-completion"

plug "zap-zsh/supercharge"
plug "zap-zsh/exa"

