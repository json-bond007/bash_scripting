#!/usr/bin/env bash
. backup.conf
shopt -s globstar extglob
backup_list() {
	# Crude locate implemanted for this script, dont want another db
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
backup_list
shopt -u globstar extglob
