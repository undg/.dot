#!/bin/sh
# X11 init file. Runs on XORG server start.
# Executed by startx (run your window manager from here)

eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

# automount utility for udisks2 (udisksctl)
udiskie &

# speedy keys
# xset r rate 200 100
exec ~/bin/speedy-keys.sh

exec i3

