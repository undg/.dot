#!/usr/bin/env bash
# Pull: settings-example.json → settings.json
# Merges only tracked keys from example into live config, leaving everything else untouched.
# Run this after pulling dotfiles to pick up new extensions/packages/config.
set -euo pipefail

PI_CONFIG_DIR="${PI_CONFIG_DIR:-$HOME/.config/pi}"
SETTINGS="$PI_CONFIG_DIR/settings.json"
EXAMPLE="$PI_CONFIG_DIR/settings-example.json"

TRACKED='{npmCommand, extensions, packages, theme}'

for f in "$SETTINGS" "$EXAMPLE"; do
	if [[ ! -f "$f" ]]; then
		echo "ERROR: $f not found" >&2
		exit 1
	fi
done

tmp=$(mktemp)
jq -s '.[0] * (.[1] | '"$TRACKED"')' "$SETTINGS" "$EXAMPLE" > "$tmp"
cat "$tmp" > "$SETTINGS"
rm "$tmp"
echo "Pulled tracked keys → $SETTINGS"
