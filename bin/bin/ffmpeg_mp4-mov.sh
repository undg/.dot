#!/bin/env sh

if [ "$1" = "help" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
	printf "
	script.sh [file1 file2 file3 ...]
		If no arguments are passed, all files in current folder will be processed.

	help --help -h
		This help message.
	\n"
	exit 0
fi

R='\033[0;31m' #'0;31' is Red's ANSI color code
G='\033[0;32m' #'0;32' is Green's ANSI color code
Y='\033[1;32m' #'1;32' is Yellow's ANSI color code
B='\033[0;34m' #'0;34' is Blue's ANSI color code
NC='\033[0m'   #'0'    is back no color

printf "
${R}Compressed media will land in mov folder!
${NC}Press ANY key to continue.\n"
read

CURRENT_DIR=$(pwd)
if [ $# -eq 0 ]; then
	files=* # all files in current dir
else
	files=$@ # files passed as an arguments
fi

OUT_DIR="mov"
if [ ! -d "$OUT_DIR" ]; then
	mkdir "$OUT_DIR"
fi

for f in $files; do
	f_date=$(date -r "$f" +"%Y-%m-%d_%H-%M-%S")
ff_fullname="${f##*/}"
	f_name="${f_fullname%.*}"
	f_ext=${f##*.}
	f_out="$OUT_DIR"/"$f_date"__"$f_name".mov

	printf "\n${B}~~~~~~>${G} $CURRENT_DIR/$f ${B}===>${G} $f_out ${NC}\n"
	ffmpeg -i "$f" -vcodec dnxhd -acodec pcm_s16le -s 1920x1080 -r 30000/1001 -b:v 36M -pix_fmt yuv422p -f mov "$f_out"
done
