#!/bin/bash
PLUGIN_DIR="$CONFIG_DIR/plugins"
ITEM_DIR="$CONFIG_DIR/items"

sketchybar --add item cpu right \
	--set cpu  update_freq=2 \
	icon=􀧓  \
	script="$PLUGIN_DIR/cpu.sh"
