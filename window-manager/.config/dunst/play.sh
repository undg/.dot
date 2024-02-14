#!/bin/sh

ignore_apps=("Spotify" "Kodi" "zsh")

for app in "${ignore_apps[@]}"; do
  if [ "$app" = "$1" ]; then
    exit 1
  fi
done

paplay ~/.config/dunst/beep.wav
