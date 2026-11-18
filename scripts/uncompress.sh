#!/usr/bin/env bash

#!/usr/bin/env bash

# Challenge use the output of the command file to do the
# switch statement
uncompress() {
	local i
	local filetype
	mapfile -t -d ' ' files < <(printf '%s ' "$@")

	for ((i = 0; ${#files[@]} > i; i++)); do
		if [[ -e "${files[$i]}" ]]; then
			filetype=$(file --mime-type "${files[$i]}" | cut -d ':' -f 2 -)
			case $filetype in
			*.)
				tar xvjf "${files[$i]}"
				;;
			*bzip2 | *bzip)
				bunzip2 "${files[$i]}"
				;;
			*tar)
				tar xvf "${files[$i]}"
				;;
			*gzip)
				gzip -d "${files[$i]}"
				;;
			*7z-compressed)
				7z -y e "${files[$i]}"
				;;
			*zip-compressed)
				gunzip -d "${files[$i]}"
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
