#! /bin/bash
# source:
# https://gist.github.com/fatihkaan22/0cad6b53647c5d887c67b22c260568cb

# One liner that's works
pacmd list-clients \
  | awk '($1 == "index:") {i=$2} ($1 == "application.name" && tolower($0) ~ /spotify/) {print i}' \
  | head -n-1 \
  | xargs -n1 pacmd kill-client >> /tmp/cron-kill-spotify.log

# # This one is broken in line with unset. EE msg in comment.
# spotifyInstances=()

# while read LINE1; read LINE2; do
# 	IFS=':-='

# 	read -ra L1 <<< $LINE1
# 	read -ra L2 <<< $LINE2

# 	# trim leading/trailing spaces for error checking
# 	INDEX_STR=$(echo "${L1[0]}" | xargs)
# 	NAME_STR=$(echo "${L2[0]}" | xargs)

# 	if [[ $INDEX_STR != 'index' || $NAME_STR != 'application.name' ]]; then
# 		echo 'ERROR'
# 		exit
# 	fi

# 	INDEX=${L1[1]}
# 	NAME=${L2[1]}

# 	if [[ $NAME == ' "Spotify"' ]]; then
# 		spotifyInstances+=( $INDEX )
# 	fi

# done < <(pacmd list-clients | grep -e 'index:' -e 'application.name')

# # remove last element (active client)
# unset 'spotifyInstances[${#arr[@]}-1]'
# # EE: /home/undg/.zprezto/bin/spotify-kill-pulse-client.sh: line 32: unset: [${#arr[@]}-1]: bad array subscript

# for s in ${spotifyInstances[@]}; do
# 	echo "pacmd kill-client $s"
# 	pacmd kill-client $s
# done

