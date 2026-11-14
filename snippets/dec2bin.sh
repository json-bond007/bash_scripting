#!/bin/env bash

# Let user input digit and return the binary formated as a string
# example, IP address, then do some operaions on it

mapfile -t -d '.' ip_address < <(echo -n "$1")

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
		dec2binary "$n" | rev
	done
	echo
}

main
