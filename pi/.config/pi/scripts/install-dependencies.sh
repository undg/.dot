#!/usr/bin/env bash
set -euo pipefail

PI_CONFIG_DIR="${PI_CONFIG_DIR:-$HOME/.config/pi}"

install_dependencies() {
	local dir=$1

	if [[ ! -f "$dir/package.json" ]]; then
		echo "Skipping dependency install in $dir (package.json not present)"
		return
	fi

	echo "Installing Pi extension dependencies in $dir"
	(cd "$dir" && pnpm install)
}

if ! command -v pnpm >/dev/null 2>&1; then
	echo "ERROR: pnpm is required to install Pi extension dependencies" >&2
	exit 1
fi

install_dependencies "$PI_CONFIG_DIR/extensions/pi-notifier"
install_dependencies "$PI_CONFIG_DIR/npm"
