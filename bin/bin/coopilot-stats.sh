#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

##############################
# Fetch stats; set variables
##############################

TOKEN=$(gh auth token -h github.com)
[ -z "$TOKEN" ] && echo "Error: GitHub token not found" && exit 1
STATS=$(curl -s -H "Authorization: Token $TOKEN" https://api.github.com/copilot_internal/user)
echo "$STATS" | jq -e '.quota_reset_date and .quota_snapshots.premium_interactions' >/dev/null || {
	echo "Error: Unexpected GitHub API response"
	echo "$STATS" | jq -r '.message // empty'
	exit 1
}

RESET_DATE=$(echo "$STATS" | jq -r '.quota_reset_date | split("T")[0]')
PREV_RESET_DATE=$(date -j -v-1m -f "%Y-%m-%d" "$RESET_DATE" "+%Y-%m-%d")
RESET_TS=$(date -j -f "%Y-%m-%d" "$RESET_DATE" "+%s")
PREV_RESET_TS=$(date -j -f "%Y-%m-%d" "$PREV_RESET_DATE" "+%s")
NOW_TS=$(date "+%s")
DAYS_LEFT=$(((RESET_TS - NOW_TS + 86399) / 86400))
CYCLE_DAYS=$(((RESET_TS - PREV_RESET_TS) / 86400))
if [ "$CYCLE_DAYS" -le 0 ]; then
	CYCLE_DAYS=30
fi
DAYS_LEFT_PERCENT=$((DAYS_LEFT * 100 / CYCLE_DAYS))

######################
# Show stats
######################

echo -e "$(echo "$STATS" | jq -r --arg GREEN "$GREEN" --arg RED "$RED" --arg CYAN "$CYAN" --arg MAGENTA "$MAGENTA" --arg NC "$NC" --argjson DAYS_LEFT "$DAYS_LEFT" --argjson DAYS_LEFT_PERCENT "$DAYS_LEFT_PERCENT" --argjson CYCLE_DAYS "$CYCLE_DAYS" '
  def remaining_color:
    (.quota_snapshots.premium_interactions.percent_remaining | floor) as $percent_remaining |
    (($DAYS_LEFT * 100) / $CYCLE_DAYS | floor) as $days_left_percent |
    if $percent_remaining < $days_left_percent then $RED
    elif $percent_remaining < ($days_left_percent + 10) then $MAGENTA
    else $GREEN
    end;

  "🔐 User: \(.login)\n" +
  "📦 Plan: \(.copilot_plan)\n" +
  "🏢 Organizations: \(.organization_list | map(.name) | join(", "))\n" +
  "📅 Access since: \(.assigned_date | split("T")[0])\n\n" +
  "✨ Features:\n" +
  "  Chat: \(if .chat_enabled then $GREEN + "true" + $NC else $RED + "false" + $NC end)\n" +
  "  CLI: \(if .cli_enabled then $GREEN + "true" + $NC else $RED + "false" + $NC end)\n" +
  "  MCP: \(if .is_mcp_enabled then $GREEN + "true" + $NC else $RED + "false" + $NC end)\n" +
  "  Preview Features: \(if .editor_preview_features_enabled then $GREEN + "true" + $NC else $RED + "false" + $NC end)\n" +
  "  Cloud Session Storage: \(if .cloud_session_storage_enabled then $GREEN + "true" + $NC else $RED + "false" + $NC end)\n" +
  "  Restricted Telemetry: \(if .restricted_telemetry then $GREEN + "true" + $NC else $RED + "false" + $NC end)\n\n" +
  "💰 Billing:\n" +
  "  Model: \(if .token_based_billing then "Token-based" else "Seat-based" end)\n" +
  "  Can upgrade: \(if .can_upgrade_plan then $GREEN + "true" + $NC else $RED + "false" + $NC end)\n\n" +
  "📊 Premium Requests:\n" +
  "  Usage: \(.quota_snapshots.premium_interactions.entitlement - .quota_snapshots.premium_interactions.remaining) / \(.quota_snapshots.premium_interactions.entitlement)\n" +
  "  Remaining: \(.quota_snapshots.premium_interactions.remaining) (" + (remaining_color) + "\(.quota_snapshots.premium_interactions.percent_remaining | floor)%" + $NC + ")\n" +
  "  Overage: \(if .quota_snapshots.premium_interactions.overage_permitted then $GREEN + "Allowed" + $NC + " (\(.quota_snapshots.premium_interactions.overage_count) / \(.quota_snapshots.premium_interactions.overage_entitlement) times)" else $RED + "Not allowed" + $NC end)\n\n" +
  "📅 Reset: \(.quota_reset_date | split("T")[0])\n" +
  "  Remaining: \($DAYS_LEFT) days (" + remaining_color + "\($DAYS_LEFT_PERCENT)%" + $NC + ")"
')"

##########################
# Save stats to log file
##########################
#
# - macOS: ~/Library/Logs/coopilot-stats.csv
# - Linux: ~/.local/state/coopilot-stats/coopilot-stats.csv unless XDG_STATE_HOME set
#

if [ "$(uname -s)" = "Darwin" ]; then
	LOG_DIR="$HOME/Library/Logs"
else
	LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/coopilot-stats"
fi
LOG_FILE="$LOG_DIR/coopilot-stats.csv"

mkdir -p "$LOG_DIR"

if [ ! -f "$LOG_FILE" ]; then
	printf '%s\n' 'date,time,usage,remaining,overage,entitlement,reset,user,organizations' >>"$LOG_FILE"
fi

NEW_ROW=$(echo "$STATS" | jq -r '
  [
    (now | strftime("%Y-%m-%d")),
    (now | strftime("%H:%M:%S")),
    (.quota_snapshots.premium_interactions.entitlement - .quota_snapshots.premium_interactions.remaining),
    .quota_snapshots.premium_interactions.remaining,
    .quota_snapshots.premium_interactions.overage_count,
    .quota_snapshots.premium_interactions.entitlement,
    (.quota_reset_date | split("T")[0]),
    .login,
    (.organization_list | map(.name) | join("; "))
  ] | @csv
')

LAST_ROW=$(awk -F, 'NR > 1 { last = $0 } END { print last }' "$LOG_FILE")
LAST_DATE=$(printf '%s\n' "$LAST_ROW" | awk -F, '{ gsub(/^"|"$/, "", $1); print $1 }')
LAST_USAGE=$(printf '%s\n' "$LAST_ROW" | awk -F, '{ gsub(/^"|"$/, "", $3); print $3 }')
NEW_DATE=$(printf '%s\n' "$NEW_ROW" | awk -F, '{ gsub(/^"|"$/, "", $1); print $1 }')
NEW_USAGE=$(printf '%s\n' "$NEW_ROW" | awk -F, '{ gsub(/^"|"$/, "", $3); print $3 }')

if [ "$LAST_DATE" != "$NEW_DATE" ] || [ "$LAST_USAGE" != "$NEW_USAGE" ]; then
	printf '%s\n' "$NEW_ROW" >>"$LOG_FILE"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHART_DIR="$SCRIPT_DIR/coopilot-stats"
VENV_DIR="$CHART_DIR/.venv"
PYTHON_BIN="$VENV_DIR/bin/python"
UV_BIN="$(command -v uv)"

mkdir -p "$CHART_DIR"

if [ -z "$UV_BIN" ]; then
	echo "Error: uv not found in PATH" >&2
	exit 1
fi

if [ ! -x "$PYTHON_BIN" ]; then
	"$UV_BIN" venv "$VENV_DIR" || {
		echo "Error: failed to create chart venv with uv at $VENV_DIR" >&2
		exit 1
	}
	"$UV_BIN" pip install --python "$PYTHON_BIN" --quiet matplotlib >/dev/null || {
		echo "Error: failed to install matplotlib in $VENV_DIR with uv" >&2
		exit 1
	}
fi

"$PYTHON_BIN" -c 'import matplotlib' >/dev/null 2>&1 || {
	"$UV_BIN" pip install --python "$PYTHON_BIN" --quiet matplotlib >/dev/null || {
		echo "Error: failed to install matplotlib in $VENV_DIR with uv" >&2
		exit 1
	}
}

"$PYTHON_BIN" "$CHART_DIR/chart.py"
