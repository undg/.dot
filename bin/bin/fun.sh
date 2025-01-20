#!/bin/bash

while true; do
	clear

	fortune -s |
		cowsay -f $(shuf -n1 -e alpaca llama tux bud-frogs default) |
		nms -a -s -f $(shuf -n1 -e red blue green yellow magenta cyan white)

	sleep 15
done
