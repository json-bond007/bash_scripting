#!/usr/bin/env bash

# Using bash >=5.3r2  builtin loadable kv
# to create a associative array

enable kv
declare -A arr
kv -A arr -s -d < <(cat config_file.conf)

for i in "${!arr[@]}"; do
	echo "${arr[$i]}"
done
