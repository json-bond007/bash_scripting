#!/bin/env bash

# Let user input digit and return the binary formated as a string
#

mapfile -t -d '.' ip_address < <(echo "$1")

dec2binary() {
	local n="$1"
	while ((n != 0)); do
		result=$((n % 2))
		n=$((n / 2))
		echo -n "$result"
	done

}
main() {
	for ((i = 0; i < 5; i++)); do
		n="${ip_address[$i]}"
		dec2binary "$n"
	done
	echo
}

main
