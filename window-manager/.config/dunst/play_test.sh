#!/bin/sh

R='\033[0;31m' #'0;31' is Red's ANSI color code
G='\033[0;32m' #'0;32' is Green's ANSI color code
Y='\033[1;32m' #'1;32' is Yellow's ANSI color code
B='\033[0;34m' #'0;34' is Blue's ANSI color code
NC='\033[0m'   #'0'    is back no color


SCRIPT_PATH=~/.config/dunst/play.sh
IGNORED_APP="Spotify"
NON_IGNORED_APP="NonIgnoredApp"



if sh "$SCRIPT_PATH" "$IGNORED_APP"; then
	echo -e "$R  Test failed:$B Spotify$NC should be ignored."
else
	echo -e "$G  Test passed:$B Spotify$NC is correctly ignored."
fi

if sh "$SCRIPT_PATH" "$NON_IGNORED_APP"; then
	echo -e "$G  Test passed:$B NonIgnoredApp$NC is not ignored as expected."
else
	echo -e "$R  Test failed:$B NonIgnoredApp$NC should not be ignored."
fi
