#!/usr/bin/env bash

ffmpeg -i $1 -vf yadif -codec:v libx264 -crf 1 -bf 2 -flags +cgop -pix_fmt yuv420p -codec:a aac -strict -2 -b:a 384k -r:a 48000 -movflags faststart $2
