#!/usr/bin/env bash

declare -A 2darray

declare i=0
for ((row = 0; row < 10; row++)); do
	for ((col = 0; col < 4; col++)); do
		echo "2darray['$row,$col']=$i"
		((i++))
	done
done
raw2draw='a,b,c,d
e,f,g
h,i,,k
l,,n,o'

2readarray() {
	local raw2draw="$1"
	local row="$2"
	local col="$3"
	local sep="${4:-,}"
	local alpharow alpharows
	IFS=$'\n' readarray -t alpharows < <(printf '%s' "$raw2draw")
	if [[ $row -ge ${#alpharows[@]} ]]; then
		echo "Bad row."
		return
	fi
	IFS="$sep" read -ra alpharow < <(printf '%s' "${alpharows[$row]}")
	if [[ $col -ge ${#alpharow[@]} ]]; then
		echo "Bad column."
		return
	fi
	echo "${alpharow[$col]}"
}
