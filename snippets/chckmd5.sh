#!/bin/env bash

# Check the file md5sum matches what it expected after or before being copied

shopt -s extglob
file="$1"
destination="${2%/}"

: ${file?"You need to provide the file"} ${destination?"You also need to provide the destination"}

chckmd5sum() {
	# Take two arguments and do a string comparison on it
	local file1
	local file2
	file1=$(md5sum "$1")
	file2=$(md5sum "$2")
	file1="${file1%% *}"
	file2="${file2%% *}"
	if [[ "$file1" == "$file2" ]]; then
		return 0
	fi
}

# Main method of the snippet
main() {
	local cpfile="${destination}/${file}"
	echo cp --target-directory="$destination" "$file"
	if chckmd5sum "$file" "$cpfile"; then
		printf '%s\n' "The file md5sum do match"
	else
		printf '%s\n' "The file md5sum dont match"
	fi
}

main
shopt -u extglob
