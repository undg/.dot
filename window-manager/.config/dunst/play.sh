#!/bin/sh

ignore_apps=("Spotify" "Kodi")

for app in "${ignore_apps[@]}"; do
  if [ "$app" = "$1" ]; then
    exit 0
  fi
done

paplay ~/.config/dunst/beep.wav
