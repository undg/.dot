#!/bin/sh
# X11 init file. Runs on XORG server start.

eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

# automount utility for udisks2 (udisksctl)
udiskie &

# speedy keys
xset r rate 250 80

exec i3

