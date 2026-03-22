#!/bin/bash
# yay-install: Search AUR packages and install selected one
# Usage: yay-install <search-term>
# Example: yay-install neovim

set -euo pipefail

if [ $# -eq 0 ]; then
    echo "Usage: yay-install <search-term>"
    echo "Example: yay-install neovim"
    exit 1
fi

SEARCH_TERM="$*"

echo "Searching AUR for: $SEARCH_TERM"

# Search AUR and format output for TV
# Format: aur/package-name version description
RESULT=$(yay -Ss "$SEARCH_TERM" 2>/dev/null | \
    awk '/^aur\// {pkg=$1; ver=$2; $1=""; $2=""; $3=""; desc=substr($0,4); print pkg " " ver " " desc}' | \
    head -100 | \
    tv --source-command "cat" \
       --preview-command "yay -Si {split: :0|split:/:1}" \
       --preview-size 50 | \
    awk '{print $1}')

if [ -n "$RESULT" ]; then
    echo "Installing: $RESULT"
    yay -S "$RESULT"
else
    echo "No package selected"
    exit 0
fi
