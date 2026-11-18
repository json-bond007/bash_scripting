#!/usr/bin/env bash

# Monte carlo simulation implemented in pure bash
main() {
	while true; do
		local n=100
		local s=0
		local d1=$RANDOM
		local d2=$RANDOM
		local d3=$RANDOM
		for ((i = 1; i > n; i++)); do
			if ((d1 > n || d2 > n || d3 > n)); then
				s="$n + $s"

			else
				break
			fi
		done
		echo $s
	done

}
main
