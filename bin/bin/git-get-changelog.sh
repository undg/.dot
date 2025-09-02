#!/bin/bash

# Get last tag
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null)

if [ -z "$LAST_TAG" ]; then
    echo "No tags found in repository"
    exit 1
fi

echo "Last tag: $LAST_TAG"

# Get current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Get all merged commits since last tag
echo ""
echo "Merged commits since $LAST_TAG on branch $CURRENT_BRANCH:"
echo "=================================================="

# Use git log to get commits since last tag
git --no-pager log --format="%h %s" --merges "${LAST_TAG}..${CURRENT_BRANCH}" 

# echo ""
# echo "All commits (including non-merge) since $LAST_TAG:"
# echo "=================================================="
#
# git log --oneline "${LAST_TAG}..${CURRENT_BRANCH}"

echo ""
echo "Next version suggestions:"

# Parse current version (with or without v prefix)
if [[ $LAST_TAG =~ ^(v?)([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
    PREFIX=${BASH_REMATCH[1]}
    MAJOR=${BASH_REMATCH[2]}
    MINOR=${BASH_REMATCH[3]}
    PATCH=${BASH_REMATCH[4]}
    
    # Calculate next versions keeping same prefix
    NEXT_MAJOR="${PREFIX}$((MAJOR + 1)).0.0"
    NEXT_MINOR="${PREFIX}${MAJOR}.$((MINOR + 1)).0"
    NEXT_PATCH="${PREFIX}${MAJOR}.${MINOR}.$((PATCH + 1))"
    
    echo "Major: $NEXT_MAJOR (breaking changes)"
    echo "Minor: $NEXT_MINOR (new features)"
    echo "Patch: $NEXT_PATCH (bug fixes)"
else
    echo "Major: (breaking changes)"
    echo "Minor: (new features)" 
    echo "Patch: (bug fixes)"
fi
