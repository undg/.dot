#!/usr/bin/env sh

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    defaults write -g InitialKeyRepeat -int 10  # ~150ms delay
    defaults write -g KeyRepeat -int 1          # very fast repeat
elif command -v xset >/dev/null 2>&1; then
    # Linux/X11
    xset r rate 200 100
else
    echo "Unsupported system"
fi
