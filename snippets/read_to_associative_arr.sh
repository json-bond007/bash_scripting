#!/usr/bin/env bash
shopt -s extglob

main() {
	declare -A arr
	declare n
	for n in {a,b,c,d}; do
		while read -u 3 -r line; do
			arr["${n}_${line%%=*}"]="${line##*=} ${n}"

		done 3<"$1"
	done
	echo "${!arr[@]}" = "${arr[@]}"
}

main "$1"
shopt -u extglob
