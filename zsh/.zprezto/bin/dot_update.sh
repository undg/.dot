#!/bin/sh
[ -z ${reposfile+x} ] && reposfile="https://raw.githubusercontent.com/und3rdg/dot_install/master/repos.csv"

git_pull_loop() {
	([ -f "$reposfile" ] && cp "$reposfile" /tmp/repos.csv) || curl -Ls "$reposfile" | sed '/^#/d' > /tmp/repos.csv
	total=$(wc -l < /tmp/repos.csv)
	while IFS=, read -r url dest; do
    echo ""
    echo "___________________________________________"
    echo "$url"
    echo " $HOME/$dest"
    git -C "$HOME/$dest/" pull
	done < /tmp/repos.csv 
}

git_pull_loop
