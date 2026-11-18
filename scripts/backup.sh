#!/usr/bin/env bash

# Script to run backup functions
# On gnu-linux
# Optional depencies: gum for prettier output
. backup.conf

LC_ALL=C

chck_root() {
	if ((UID = 0)); then
		return 0
	fi
}
chck_os() {
	if [[ $OSTYPE == "linux-gnu" ]] || [[ $OSTYPE = *bsd ]]; then

		return 0
	fi
}

get_args() {
	local -a ARGS
	ARGS=("$@")
	for ((i = 0; BASH_ARC <= i; i++)); do
		case "${ARGS[$i]}" in
		list)
			backup_list
			;;
		config)
			backup_config
			;;
		restore)
			backup_restore
			;;
		backup)
			backup_backup
			;;

		*)
			printf '%s' "${0##*/} needs one or more ${ARGS[*]}"
			;;
		esac
	done
}
chck_conf() {
	local validate_dir
	: ${target_dir?"You need to define the dir"} ${source_dirs?"You need to define source dirs"} ${max_backups?"databases"} ${databases?"databases needs at least one option"}

	validate_dir=$(stat -c '%f' "${source_dirs[*]}")
	if [[ -e "${target_dir}" ]] && [[ "$validate_dir" =~ (*directory*)+ ]] && [[ "${databases[*]}" =~ (\s?[0-9]+ [[:alnum:]]+ [[:alnum:]]+ [[:alnum:]]+)+ ]] && [[ "${max_backups}" =~ ^[0-9]+$ ]]; then
		return 0
	fi
}

backup_list() {
	if which gum >/dev/null; then
		:
	else
		:
	fi
}
