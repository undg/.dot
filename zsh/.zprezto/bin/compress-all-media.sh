#!/bin/bash
echo -e "All files will be renamed and overrides with ffmpeg.\n CTRL+C to break.\n Press ANY key to continue."
read


R='\033[0;31m'   #'0;31' is Red's ANSI color code
G='\033[0;32m'   #'0;32' is Green's ANSI color code
Y='\033[1;32m'   #'1;32' is Yellow's ANSI color code
B='\033[0;34m'   #'0;34' is Blue's ANSI color code
NC='\033[0m'     #'0'    is back no color

path=$(pwd)

for f in *
do
    f_date=$(date -r "$f" +"%Y-%m-%d_%H-%M-%S")
    f_ext=${f##*.}
    name="$f_date.$f_ext"

    echo ""
    echo -e "${B}~~~~~~>${G} $path/$f ${B}===>${G} $name ${NC}" 
    echo ""
    ffmpeg -i $f $name && trash $f
done

