#!/usr/bin/env bash

# Detect USB device upon udev event then if users inserts it
# get its id and canonical dev name and store its values in a array,
# then copy the ls from $PWD to a compressed file with gzip to said device
# else stop after 12 seconds
# Extra: add zentiy instead of read to get the user prompt
#

main() {

	while read line; do
		if [[ -t "$line" ]]; then
			echo "!"
		else
			echo "$line"
		fi
	done <"$1"

}

main "$1"
