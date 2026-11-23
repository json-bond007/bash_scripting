#!/usr/bin/env bash

# Script to run backup functions in pure bash
# On gnu-linux
# Optional depencies: gum for prettier output
. backup.conf

export LC_ALL=C

shopt -s globstar
shopt -s extglob
shopt -s failglob

chck_root() {
	if ((UID == 0)); then
		return 0
	fi
}
chck_os() {
	if [[ $OSTYPE == "linux-gnu" ]] || [[ $OSTYPE = *bsd ]]; then

		return 0
	fi
}
fmt_c() {
	local hostname=$(hostnamectl --static hostname)
	local date="$1"
	local sysdate
	local backups="$2"
	local fmt_string
	printf -v sysdate '%(%F-%T)T'
	date="$(date --iso-8601=seconds --date="${date}")"
	: "${date:=$sysdate}" "${backups?"Err must supply backups specifier"}"
	printf -v fmt_string '%s' "${date}-${hostname}-${backups}"
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
# Config parser and validator
chck_conf() {
	local validate_dir
	: ${target_dir?"You need to define the dir"} ${source_dirs?"You need to define source dirs"} ${max_backups?"databases"} ${databases?"databases needs at least one option"}

	# Validate configuration variables
	validate_dir=$(stat -c '%f' "${source_dirs[*]}")
	if [[ -e "${target_dir}" ]] && [[ "$validate_dir" =~ (*directory*)+ ]] && [[ "${databases[*]}" =~ (\s?[0-9]+ [[:alnum:]]+ [[:alnum:]]+ [[:alnum:]]+)+ ]] && [[ "${max_backups}" =~ ^[0-9]+$ ]]; then
		return 0
	fi
	# Extract/implode substrings into new array for each database, as db_1..db_n
	for ((i = 0; i < ${#databases[@]}; i++)); do
		declare "db_${i}=${databases[$i]}"
		name="db_${i}"
		array="dbs_${i}"
		mapfile -d ' \n' -t "${array}" < <(printf '%s' "${!name}")
	done

}

backup_list() {
	chck_conf
	local files
}

backup_config() {

	printf '%s\n' "${target_dir}" "${source_dirs}" "${max_backups}" "${databases}"

}

shopt -n failglob
shopt -n extglob
shopt -n globstar
