#!/bin/bash
set -euo pipefail

# Retrieve a Pi provider API key from the OS keyring.
# Linux: libsecret (secret-tool)
# macOS: Keychain (security)

provider="${1:-}"
if [ -z "$provider" ]; then
	echo "Usage: ${0##*/} <provider>" >&2
	exit 1
fi

if command -v secret-tool >/dev/null 2>&1; then
	# Linux / GNOME Keyring / libsecret
	secret-tool lookup service "$provider"
elif command -v security >/dev/null 2>&1; then
	# macOS Keychain
	security find-generic-password -s "$provider" -w
else
	echo "No keyring backend found. Install secret-tool (libsecret-tools) on Linux or use macOS Keychain." >&2
	exit 1
fi
