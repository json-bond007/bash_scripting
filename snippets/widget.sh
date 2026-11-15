#!/bin/env bash

# For further info see https://tldp.org/LDP/abs/abs-guide.pdf
# Prompt user with gtk widget using zenity

get_info() {
	zenity --entry # Pops up query window . . .
	#+ and prints user entry to stdout.
	# Also try the --calendar and --scale options.
}
answer=$(get_info) # Capture stdout in $answer variable.
echo "User entered: $answer"
