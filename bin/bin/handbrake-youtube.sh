#!/bin/env sh
R='\033[0;31m' #'0;31' is Red's ANSI color code
G='\033[0;32m' #'0;32' is Green's ANSI color code
Y='\033[1;32m' #'1;32' is Yellow's ANSI color code
B='\033[0;34m' #'0;34' is Blue's ANSI color code
NC='\033[0m'   #'0'    is back no color

PRESET_JSON="~/bin/handbrake-youtube-preset.sh"


if [[ $# -eq 0 ]] || [[ "$1" =~ ^(-h|--help|help)$ ]]; then
	printf "
	script.sh [file1 file2 file3 ...]
		If no arguments are passed, all files in current folder will be processed.

	help --help -h
		This help message.
	\n"
	exit 0
fi

CURRENT_DIR=$(pwd)
# @TODO (undg) 2024-06-28: fix files with spaces in names
files=$@ # files passed as an arguments

for f in $files; do
	f_date=$(date -r "$f" +"%Y-%m-%d_%H-%M-%S")
	f_fullname="${f##*/}"
	f_name="${f_fullname%.*}"
	f_ext=${f##*.}
	f_out="$f_name-handbrake.mp4"

	printf "\n${B}~~~~~~>${G} $CURRENT_DIR/$f ${B}===>${G} $f_out ${NC}\n"

	HandBrakeCLI --preset-import-file "$PRESET_JSON" -i "$f" -o "$f_out"

	notify-send "handbraked: $f"
done

notify-send "handbraked-all: $files"
