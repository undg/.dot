#!/bin/bash
# Filter env vars to censor sensitive values
# Usage: tv-env-filter.sh [preview|source]

SENSITIVE_PATTERNS='(api|pass|secret|key|token|auth|atuin)'

filter_env() {
    while IFS='=' read -r name value; do
        if echo "$name" | grep -qiE "$SENSITIVE_PATTERNS"; then
            echo "$name=**********"
        else
            echo "$name=$value"
        fi
    done
}

case "${1:-source}" in
    source)
        printenv | filter_env
        ;;
    preview)
        # Read from stdin for preview
        while IFS= read -r line; do
            name="${line%%=*}"
            if echo "$name" | grep -qiE "$SENSITIVE_PATTERNS"; then
                echo "**********"
            else
                echo "${line#*=}"
            fi
        done
        ;;
esac
