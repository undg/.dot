#!/bin/bash

#!/bin/env sh
R='\033[0;31m' #'0;31' is Red's ANSI color code
G='\033[0;32m' #'0;32' is Green's ANSI color code
Y='\033[1;32m' #'1;32' is Yellow's ANSI color code
B='\033[0;34m' #'0;34' is Blue's ANSI color code
NC='\033[0m'   #'0'    is back no color

if [[ $# -eq 0 ]] || [[ "$1" =~ ^(-h|--help|help)$ ]]; then
	printf "
	script.sh [file1 file2 file3 ...]
		If no arguments are passed, all files in current folder will be processed.

	help --help -h
		This help message.
	\n"
	exit 0
fi

printf "
${R}Compressed media will land in same folder!
${NC}Press ANY key to continue.\n"
read

files=("$@") # files passed as an arguments

for f in "${files}"; do
	f_dir=$(dirname "$(realpath "$f")")
	f_date=$(date -r "$f" +"%Y-%m-%d_%H-%M-%S")
	f_fullname="${f##*/}"
	f_name="${f_fullname%.*}"
	f_ext=${f##*.}
	f_out="$f_dir"/"$f_name"-youtube.mp4

	printf "\n${B}~~~~~~>${G} $f_dir/$f ${B}===>${G} $f_out ${NC}\n"

	ffmpeg -i "$f" \
		-c:v hevc_vaapi \
		-vaapi_device /dev/dri/renderD128 \
		-vf 'format=nv12,hwupload,fps=30000/1001' \
		-profile:v main \
		-level:v 5.2 \
		-rc_mode CQP \
		-qp 28 \
		-g 30 \
		-keyint_min 15 \
		-bf 2 \
		-c:a aac \
		-b:a 196k \
		-movflags +faststart \
		"$f_out"

	notify-send "transcoded: $f"
done

notify-send "transcoded-all: $files"
