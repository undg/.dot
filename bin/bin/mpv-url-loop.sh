#!/usr/bin/env bash

while IFS= read -r url; do
	[[ -z "$url" ]] && continue
	mpv --fullscreen "$url"
done
