#! /bin/bash
# source:
# https://gist.github.com/fatihkaan22/0cad6b53647c5d887c67b22c260568cb

spotifyInstances=()

while read LINE1; read LINE2; do
	IFS=':-='

	read -ra L1 <<< $LINE1
	read -ra L2 <<< $LINE2

	# trim leading/trailing spaces for error checking
	INDEX_STR=$(echo "${L1[0]}" | xargs)
	NAME_STR=$(echo "${L2[0]}" | xargs)

	if [[ $INDEX_STR != 'index' || $NAME_STR != 'application.name' ]]; then
		echo 'ERROR'
		exit
	fi

	INDEX=${L1[1]}
	NAME=${L2[1]}

	if [[ $NAME == ' "Spotify"' ]]; then
		spotifyInstances+=( $INDEX )
	fi

done < <(pacmd list-clients | grep -e 'index:' -e 'application.name')

# remove last element (active client)
unset 'spotifyInstances[${#arr[@]}-1]'

for s in ${spotifyInstances[@]}; do
	echo "pacmd kill-client $s"
	pacmd kill-client $s
done
