#!/bin/sh

pidof pavucontrol >/dev/null && killall pavucontrol || pavucontrol >/dev/null &
