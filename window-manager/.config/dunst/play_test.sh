#!/bin/sh

R='\033[0;31m' #'0;31' is Red's ANSI color code
G='\033[0;32m' #'0;32' is Green's ANSI color code
Y='\033[1;32m' #'1;32' is Yellow's ANSI color code
B='\033[0;34m' #'0;34' is Blue's ANSI color code
NC='\033[0m'   #'0'    is back no color


SCRIPT_PATH="/home/undg/.config/dunst/play.sh"
IGNORED_APP="Spotify"



if sh ~/.config/dunst/play.sh "$IGNORED_APP"; then
	printf "${R}Test failed:$NC Spotify should be ignored.\n"
else
	printf "${G}Test passed:$NC Spotify is correctly ignored.\n"
fi

if sh "$SCRIPT_PATH" NonIgnoredApp; then
	printf "${G}Test passed:$NC NonIgnoredApp is not ignored as expected.\n"
else
	printf "${R}Test failed:$NC NonIgnoredApp should not be ignored.\n"
fi
