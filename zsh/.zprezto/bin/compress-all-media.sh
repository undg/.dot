#!/bin/bash

if [ "$1" = "help" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
then
  printf "
    compress-all-media.sh [file1 file2 file3 ...]
        If no arguments are passed, all files in current folder will be compressed.

    help --help -h
        This help message.
    \n"
  exit 0
fi

R='\033[0;31m'   #'0;31' is Red's ANSI color code
G='\033[0;32m'   #'0;32' is Green's ANSI color code
Y='\033[1;32m'   #'1;32' is Yellow's ANSI color code
B='\033[0;34m'   #'0;34' is Blue's ANSI color code
NC='\033[0m'     #'0'    is back no color

printf "
${R}All media files will be renamed and overrides with ffmpeg!
${NC}Press ANY key to continue.\n"
read

current_dir=$(pwd)
if [ $# -eq 0 ]; then
  files=* # all files in current dir
else
  files=$@ # files passed as an arguments
fi

for f in $files 
do
    f_date=$(date -r "$f" +"%Y-%m-%d_%H-%M-%S")
    f_fullname="${f##*/}"
    f_name="${f_fullname%.*}"
    f_ext=${f##*.}
    __="__"
    name="$f_date$__$f_name.$f_ext"

    printf "\n${B}~~~~~~>${G} $current_dir/$f ${B}===>${G} $name ${NC}\n" 
    ffmpeg -i "$f" "$name" && trash "$f"
    # printf "$f $name\n"
done

