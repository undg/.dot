#!/bin/zsh

BRANCH=$(git branch --show-current)
TYPE=$(echo $BRANCH | awk -F'/' '{print $1}' | grep -E '^(feat|fix|style|chore|docs|perf|refactor)$' || echo "feat")
TICKET=$(echo $BRANCH | awk -F'/' '{print $2}' | grep -E '^[0-9]+$' || echo $(echo $BRANCH | awk -F'/' '{print $1}'))

LINK="${TICKET_URL}${TICKET}"

if [[ "$1" == "-o" || "$1" == "--open" ]]; then
    $BROWSER "$LINK"
else
    echo "$LINK"
fi
