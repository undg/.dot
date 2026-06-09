#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

TOKEN=$(gh auth token -h github.com)
[ -z "$TOKEN" ] && echo "Error: GitHub token not found" && exit 1
STATS=$(curl -s -H "Authorization: Token $TOKEN" https://api.github.com/copilot_internal/user)
echo -e "$(echo "$STATS" | jq -r --arg GREEN "$GREEN" --arg RED "$RED" --arg CYAN "$CYAN" --arg NC "$NC" '
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
  "  Remaining: \(.quota_snapshots.premium_interactions.remaining) (\(.quota_snapshots.premium_interactions.percent_remaining | floor)%)\n" +
  "  Overage: \(if .quota_snapshots.premium_interactions.overage_permitted then $GREEN + "Allowed" + $NC + " (\(.quota_snapshots.premium_interactions.overage_count) times)" else $RED + "Not allowed" + $NC end)\n\n" +
  "📅 Reset: \(.quota_reset_date)"
')"
