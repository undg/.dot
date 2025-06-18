#!/usr/bin/env bash

SID=$1
FOCUSED=$(aerospace list-workspaces --focused)
bg="0xff585b70"
if [ "$SID" = "$FOCUSED" ]; then
  bg="0xffb4befe"
fi
sketchybar \
  --animate sin 10 \
  --set $NAME \
  icon.color="$bg"
