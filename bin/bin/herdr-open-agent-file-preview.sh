#!/usr/bin/env bash
# preview helper for herdr-open-agent-file.sh's `tv` picker.
# arg: an absolute "path", "path:line", "path:line:col", or "path:start-end"
set -o pipefail

context=15
selection="$1"

if [[ "$selection" =~ ^(.+):([0-9]+)-([0-9]+)$ ]]; then
	file="${BASH_REMATCH[1]}"
	start="${BASH_REMATCH[2]}"
	end="${BASH_REMATCH[3]}"
elif [[ "$selection" =~ ^(.+):([0-9]+):([0-9]+)$ ]]; then
	file="${BASH_REMATCH[1]}"
	start="${BASH_REMATCH[2]}"
	end="$start"
elif [[ "$selection" =~ ^(.+):([0-9]+)$ ]]; then
	file="${BASH_REMATCH[1]}"
	start="${BASH_REMATCH[2]}"
	end="$start"
else
	file="$selection"
	start=""
fi

if [[ ! -f "$file" ]]; then
	echo "(no preview: $file not found)"
	exit 0
fi

if [[ -z "$start" ]]; then
	bat --color=always --style=numbers --line-range :80 "$file"
	exit 0
fi

range_from=$((start > context ? start - context : 1))
range_to=$((end + context))

bat --color=always --style=numbers \
	--highlight-line "${start}:${end}" \
	--line-range "${range_from}:${range_to}" \
	"$file"
