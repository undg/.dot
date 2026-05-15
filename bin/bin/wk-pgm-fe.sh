#!/bin/sh

set -eu

RAW_BRANCH=${1:-}

if [ -z "$RAW_BRANCH" ]; then
	echo "Usage: $0 <branch-name>" >&2
	exit 1
fi

if [ "$(git rev-parse --is-bare-repository 2>/dev/null || true)" != "true" ]; then
	echo "Error: run this from a bare repository." >&2
	exit 1
fi

# slashes/spaces -> dash
# any other invalid char -> dash
# collapse repeated dashes
# trim leading and trailing  dash
SAFE_BRANCH=$(printf '%s' "$RAW_BRANCH" |
	tr '[:upper:]' '[:lower:]' |
	sed -e 's#[/[:space:]]\+#-#g' \
		-e 's#[^a-z0-9._-]#-#g' \
		-e 's#-\{2,\}#-#g' \
		-e 's#^-##' \
		-e 's#-$##')

if [ -z "$SAFE_BRANCH" ]; then
	echo "Error: branch name became empty after sanitization." >&2
	exit 1
fi

WORKTREE_DIR="./$SAFE_BRANCH"

if [ -e "$WORKTREE_DIR" ]; then
	echo "Error: worktree path already exists: $WORKTREE_DIR" >&2
	exit 1
fi

git worktree add -b "$SAFE_BRANCH" "$WORKTREE_DIR"
cd "$WORKTREE_DIR"

npm ci
npm run prepare

pwd
