#!/usr/bin/env bash

uncompress() {
	local i
	mapfile -t -d ' ' files < <(printf '%s ' "$@")

	for ((i = 0; ${#files[@]} > i; i++)); do
		if [[ -e "${files[$i]}" ]]; then
			case "${files[$i]}" in
			*.tar.bz2)
				tar xjf "${files[$i]}"
				;;
			*.bz2)
				bunzip2 "${files[$i]}"
				;;
			*.tar)
				tar xf "${files[$i]}"
				;;
			*.gz)
				gzip -d "${files[$i]}"
				;;
			*.7z)
				7z -y e "${files[$i]}"
				;;
			*)
				printf '%s\n' "None of the files could not be extracted with ${0##./}"
				;;
			esac
		else
			printf '%s\n' "file: ${files[$i]} doesnt exist"
		fi
	done
}

uncompress "$@"
