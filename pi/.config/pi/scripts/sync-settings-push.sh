#!/usr/bin/env bash
# Push: settings.json → settings-example.json
# Copies only tracked keys from live config to the example file.
# Run this before committing changes to extensions, packages, theme, etc.
set -euo pipefail

PI_CONFIG_DIR="${PI_CONFIG_DIR:-$HOME/.config/pi}"
SETTINGS="$PI_CONFIG_DIR/settings.json"
EXAMPLE="$PI_CONFIG_DIR/settings-example.json"

TRACKED='{npmCommand, extensions, packages, theme}'

if [[ ! -f "$SETTINGS" ]]; then
    echo "ERROR: $SETTINGS not found" >&2
    exit 1
fi

# Use temp file so we don't truncate EXAMPLE before jq reads it
# cat > preserves symlinks (writes through to target)
tmp=$(mktemp)
jq -s '.[1] * (.[0] | '"$TRACKED"')' "$SETTINGS" "$EXAMPLE" > "$tmp"
cat "$tmp" > "$EXAMPLE"
rm "$tmp"
echo "Pushed tracked keys → $(readlink -f "$EXAMPLE" 2>/dev/null || echo "$EXAMPLE")"
