#!/usr/bin/env bash

echo "plat[A] o [P]lomo: "
read -s -n 1 -r choice # Read 1 character (-n 1) and preserve raw input (-r)
echo
while true; do
	case "$choice" in
	A)
		echo "YEsS" && exit 0
		;;
	P)
		echo "Noo" && exit 1
		;;
	*)
		echo "bad choice, try again"
		;;
	esac
done
