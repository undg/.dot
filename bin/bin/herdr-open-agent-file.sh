#!/usr/bin/env bash
# herdr keybinding action (type = "popup"): scans the agent pane you were on
# for file:line references, lets you fuzzy-pick one, then lets you pick
# which nvim pane in the tab to open it in (not a herdr-managed sidebar).
set -o pipefail
# note: no `set -u` - macOS ships bash 3.2, which throws "unbound variable"
# on "${arr[@]}" for an empty array even when explicitly initialized

trap '
	status=$?
	if [[ $status -ne 0 ]]; then
		echo
		read -r -p "(press enter to close, exit=$status) " _ </dev/tty
	fi
' EXIT

die() {
	echo "ERROR: $1"
	exit 1
}

tab_id="${HERDR_ACTIVE_TAB_ID:-}"
[[ -n "$tab_id" ]] || die "no HERDR_ACTIVE_TAB_ID (not run via a herdr keybinding?)"

panes_json=$(herdr pane list) || die "herdr pane list failed"

pane_ids=()
while IFS= read -r pid; do
	[[ -n "$pid" ]] && pane_ids+=("$pid")
done < <(jq -r --arg tab "$tab_id" '.result.panes[] | select(.tab_id == $tab) | .pane_id' <<<"$panes_json")
[[ "${#pane_ids[@]}" -gt 0 ]] || die "no panes found in tab $tab_id"

# HERDR_ACTIVE_PANE_ID is the pane you were focused on *before* pressing the
# key - i.e. the agent pane whose output we actually want to scan. It is NOT
# this script's own temp pane (that one gets its own separate pane_id, which
# just harmlessly contributes zero candidates below since its content never
# matches the file:line regex).
agent_pane="${HERDR_ACTIVE_PANE_ID:-}"
[[ -n "$agent_pane" ]] || die "no HERDR_ACTIVE_PANE_ID (not run via a herdr keybinding?)"

# herdr pane read prints raw text directly, not JSON - no jq here
text=$(herdr pane read "$agent_pane" --source recent-unwrapped --lines 5000 --format text 2>/dev/null)

# matches path:line, path:line:col, and path:start-end (open-path.lua's
# range syntax uses a dash between the two numbers, not a second colon)
candidates=()
while IFS= read -r match; do
	[[ -n "$match" ]] && candidates+=("$match")
done < <(grep -oE '[A-Za-z0-9_./~-]+\.[A-Za-z0-9]+:[0-9]+(-[0-9]+|:[0-9]+)?' <<<"$text")
[[ "${#candidates[@]}" -gt 0 ]] || die "no file:line references found in pane $agent_pane's recent output"

# most-recently-seen first, deduplicated (avoid GNU-only `tac`, macOS has no default)
selection=$(printf '%s\n' "${candidates[@]}" | sed '1!G;h;$!d' | awk '!seen[$0]++' | fzf --prompt="open which> ")
[[ -n "$selection" ]] || exit 0

end_line=""
if [[ "$selection" =~ ^(.+):([0-9]+)-([0-9]+)$ ]]; then
	file="${BASH_REMATCH[1]}"
	line="${BASH_REMATCH[2]}"
	end_line="${BASH_REMATCH[3]}"
elif [[ "$selection" =~ ^(.+):([0-9]+):([0-9]+)$ ]]; then
	# open-path.lua's parser has no column support, so the col is dropped
	file="${BASH_REMATCH[1]}"
	line="${BASH_REMATCH[2]}"
elif [[ "$selection" =~ ^(.+):([0-9]+)$ ]]; then
	file="${BASH_REMATCH[1]}"
	line="${BASH_REMATCH[2]}"
else
	file="$selection"
	line=""
fi

# relative paths resolve against this pane's cwd, which herdr seeds from
# HERDR_ACTIVE_PANE_CWD - same directory the agent that printed it was in
abs_file=$(realpath "$file" 2>/dev/null || printf '%s' "$file")

if [[ -n "$end_line" ]]; then
	clip_text="${abs_file}:${line}-${end_line}"
elif [[ -n "$line" ]]; then
	clip_text="${abs_file}:${line}"
else
	clip_text="$abs_file"
fi

nvim_panes=()
for pid in "${pane_ids[@]}"; do
	proc_name=$(herdr pane process-info --pane "$pid" 2>/dev/null | jq -r '.result.process_info.foreground_processes[0].name // empty')
	[[ "$proc_name" == "nvim" ]] && nvim_panes+=("$pid")
done
[[ "${#nvim_panes[@]}" -gt 0 ]] || die "no nvim pane found in tab $tab_id"

if [[ "${#nvim_panes[@]}" -eq 1 ]]; then
	nvim_pane="${nvim_panes[0]}"
else
	nvim_choices=()
	for pid in "${nvim_panes[@]}"; do
		cwd=$(jq -r --arg pid "$pid" '.result.panes[] | select(.pane_id == $pid) | .cwd // "?"' <<<"$panes_json")
		nvim_choices+=("$pid  $cwd")
	done
	nvim_chosen=$(printf '%s\n' "${nvim_choices[@]}" | fzf --prompt="target nvim pane> ")
	[[ -n "$nvim_chosen" ]] || exit 0
	nvim_pane="${nvim_chosen%% *}"
fi

# feed the existing <leader>FF workflow (lua/custom/open-path.lua) instead of
# typing raw ex commands ourselves: it already parses this clipboard format,
# opens the file, and highlights the target line/range.
printf '%s' "$clip_text" | ~/bin/yank

herdr pane send-keys "$nvim_pane" esc
herdr pane send-keys "$nvim_pane" space F F
