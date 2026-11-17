#!/usr/bin/env bash

mapfile -t -d '\n' home < <(find ~ -maxdepth 2 -type d,l,f -path '*/.*' -prune -o -not -path '.*' -print)

declare i
for i in "${home[@]}"; do
	echo "${i}"
done
