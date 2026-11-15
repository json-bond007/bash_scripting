#!/bin/bash
while true; do
	IFS= read -n 1 -s -r key
	case "$key" in
	"") echo "Enter" ;;
	" ") echo "Space" ;;
	q) echo "Quit" ;;
	*) echo "Other: $key" ;;
	esac
done
