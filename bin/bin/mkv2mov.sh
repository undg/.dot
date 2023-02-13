#!/usr/bin/env bash

ffmpeg -i $1 -map 0:0 -map 0:1 -map 0:2 -vcodec dnxhd -acodec:0 pcm_s16le -acodec:1 pcm_s16le -s 1920x1080 -r 30000/1001 -b:v 36M -pix_fmt yuv422p -f mov $2
