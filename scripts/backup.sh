#!/usr/bin/env bash

# Script to run backup functions in pure bash
# On gnu-linux
# Optional depencies: gum for prettier output
#  TODO add caching option to speed up the lisiting of directories, so I can do
#  a while loop on it :)
#  TODO make it work on multiple machines using ssh tunnel
. backup.conf
# Fuck localization
export LC_ALL=C

shopt -s globstar
shopt -s extglob
shopt -s nullglob

# Boilerpalte and helpers
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
basename() {
	# From dylan araps pure bash bibble
	# Usage: basename "path" ["suffix"]
	local tmp

	tmp=${1%"${1##*[!/]}"}
	tmp=${tmp##*/}
	tmp=${tmp%"${2/"$tmp"/}"}

	printf '%s\n' "${tmp:-/}"
}
fmt_c() {
	local hostname
	hostname=$(hostnamectl --static hostname)
	# Optional parameter
	local date="$2"
	local sysdate
	# Not optional
	local backups="$1"
	printf -v sysdate '%(%F-%T)T'
	date="$(date --iso-8601=seconds --date="${date}")"
	# Used the if else construct due to being the correct choice
	if [[ -z ${backups-} ]]; then
		return 1
	else
		: "${date:=$sysdate}"
		printf -v fmt_string "${date}-${hostname}-${backups}"
	fi
}

# Main functions
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
	# Crude locate implemented for this script, don't want another db
	#  to get the results quickly, if uptime more than 24h then reset and
	#  re-index the directories
	#  this script wil be run with anacron or systemd *.timer unit
	#  Expect runtime higher than that
	local hostname
	hostname=$(hostnamectl --static hostname)
	local files
	read -s -d ' ' -e -a uptime </proc/uptime
	if ((${uptime%.*} / 3600 >= 24)); then
		unset files
	fi
	printf '%%\n%s\n' $'\e[5m\e[2m Indexing files... \e[0m'
	files=${target_dir%*/}
	files=($target_dir/@([0-9][0-9][0-9][0-9])-@([1-9]|1[0-2])-@(0[1-9]|[12][0-9]|3[01])-@(?([1-2])[0-9]):@([0-5][0-9]):@([0-5][0-9])-$hostname-@(?([A-Z])?(a-z))*)
	printf '\tDirectories\n\t============\n\t%s\n' "${files[@]}"

}

backup_config() {

	cat <<EOF
Configuration options
=====================
 The user shall be able to configure where the 
 backup will be stored and how many may be kept
 <target_dir>:=[ABSOLUTE PATH]
 <max_backups>:=[MAX_NUMBER_OF_BACKUPS]
 <source_dirs>:=[ARRAY_SOURCE_DIR_WHERE_DB_IS_STORED]
 <dbs>:=[DB_STORED_IN_ARRAY_]
 Note there is no max number of dbs, but technicaly it 255
EOF

}

backup_backup() {
	chck_conf
	fmt_c
	local isactive
	local oldfiles=
	local -n files
	local extension_dump
	local extension_dir
	extension_dir="tar.gz"
	extenion_dump="sql.gz"
	# CUCK version, now time to fork an exec to a subhell :(
	if ((${BASH_VERSIONINFO[0]} < 5)); then
		isactive=$(systemctl is-active mariadb)
	else
		isactive=${ systemctl is-active mariadb;}
	fi
	if [[ ${isactive} != active ]]; then
		printf '%s\n' "Cowardly stopping, Did you set up the service?"
	elif command -v mysqldump; then
		:
	else
		for ((i = 0; ${#source_dirs[@]} > i; i++)); do
			fmt_c "${dbs_1[2]}"
			mysqldump -u root -p"${dbs_1[3]}" --routines -B "${dbs_1[2]}" -Y | gzip "${fmt_string}".sql.gz
			tar -cvf "$fmt_string".tar.gz "${source_dirs[$i]}" -C "${target_dir}"
			files="$fmt_string$extension_dir"
			if [[ ! -f "$files" ]]; then
				return 1
			else
				# find oldest entry
				[[ -z "$oldfiles" ]] && oldfiles="$files" || [[ "$files" -ot "$oldfiles" ]] && oldfiles="$files"
			fi
		done
	fi

}

backup_restore() {
	:
}

main() {
	if chck_root; then
		printf '%s' "Must be root"
	elif chck_os; then
		get_args "$@"
	else
		printf '%s' "Must run on unix-like"
	fi
}

main "$@"

shopt -u nullglob
shopt -u extglob
shopt -u globstar
