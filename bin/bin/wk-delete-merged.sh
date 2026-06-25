#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

git worktree list --porcelain | while IFS= read -r line; do
	if [[ $line == worktree* ]]; then
		dir=$(echo "$line" | awk '{print $2}')
	elif [[ $line == branch* ]]; then
		branch=$(echo "$line" | awk '{print $2}' | sed 's|refs/heads/||')
		state=$(cd "$dir" && gh pr view --json state --jq '.state' 2>/dev/null)
		if [[ "$state" == "MERGED" ]]; then
			echo -e "${GREEN}✓ ${CYAN}$branch ${GREEN}MERGED${NC}"
			read -p "$(echo -e ${RED}Delete worktree? \(y/n\) ${NC})" -n 1 -r </dev/tty
			echo
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				wk-pgm-fe.sh -d "$dir"
				echo -e "${RED}Deleted${NC}"
			fi
		else
			echo -e "${CYAN}$branch ${YELLOW}$state${NC}"
		fi
	fi
done
