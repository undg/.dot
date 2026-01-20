#!/bin/bash
# Helper script for gh-dash to open PR in nvim with gh.nvim
# Arguments: $1 = PR number, $2 = repo path

PR_NUMBER="$1"
REPO_PATH="$2"

cd "$REPO_PATH" || exit 1
gh pr checkout "$PR_NUMBER" || exit 1

# Count panes (excluding the current new pane)
pane_count=$(tmux list-panes | wc -l | tr -d " ")

if [ "$pane_count" -eq 2 ]; then
  # Only one pane existed before: just open nvim here
  nvim -c ":GHOpenPr $PR_NUMBER"
else
  # Multiple panes: check if one has nvim running
  has_nvim=0
  for pane in $(tmux list-panes -F "#{pane_index}"); do
    cmd=$(tmux display-message -p -t "$pane" "#{pane_current_command}")
    if echo "$cmd" | grep -q nvim; then
      # Found nvim pane: switch to it and send command
      has_nvim=1
      tmux select-pane -t "$pane"
      tmux send-keys ":GHOpenPr $PR_NUMBER" Enter
      break
    fi
  done
  
  if [ "$has_nvim" -eq 0 ]; then
    # No nvim found: find another pane and open nvim there
    current_pane=$(tmux display-message -p "#{pane_index}")
    other_pane=$(tmux list-panes -F "#{pane_index}" | grep -v "^$current_pane$" | head -n1)
    if [ -n "$other_pane" ]; then
      tmux select-pane -t "$other_pane"
      tmux send-keys "nvim -c ':GHOpenPr $PR_NUMBER'" Enter
    else
      # Fallback: just open here
      nvim -c ":GHOpenPr $PR_NUMBER"
    fi
  fi
fi
