#!/usr/bin/env bash

# Function that checks if input it's string (return 1), or int(return 0 )

is_int() {
	local input="$1"
	if [[ $input =~ ^[0-9]+$ ]]; then
		return 0
	fi

}
