#!/bin/bash
# yay-search: Search AUR packages with fuzzy finder
# Usage: yay-search <search-term>
# Example: yay-search neovim

set -euo pipefail

if [ $# -eq 0 ]; then
    echo "Usage: yay-search <search-term>"
    echo "Example: yay-search neovim"
    exit 1
fi

SEARCH_TERM="$*"

echo "Searching AUR for: $SEARCH_TERM"

# Search AUR and format output for TV
# Format: aur/package-name version description
yay -Ss "$SEARCH_TERM" 2>/dev/null | \
    awk '/^aur\// {pkg=$1; ver=$2; $1=""; $2=""; $3=""; desc=substr($0,4); print pkg " " ver " " desc}' | \
    head -100 | \
    tv --source-command "cat" \
       --preview-command "yay -Si {split: :0|split:/:1}" \
       --preview-size 50
