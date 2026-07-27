# Permissions system

Read only tools and bash commands should be `allow`.
Tools and commands with destructive capabilities should be `ask`.
Tools and commands that are danger and unpredictable should be `deny`.

The goal is to interrupt user as little as possible, but protect system from unpredictability of llm agents.

Config is in `~/.dot/pi/.config/pi/extensions/pi-permission-system/config.json`
Log is in `~/.dot/pi/.config/pi/extensions/pi-permission-system/logs/pi-permission-system-permission-review.jsonl`
