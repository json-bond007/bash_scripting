#!/usr/bin/env bash

# Detect USB device upon udev event then if users inserts it
# get its id and canonical dev name and store its values in a variable
# then copy the ls from $HOME to a compressed file with gzip to said device
# else stop after 12 seconds
# Extra: add zenity instead of read to get the user prompt
#
shopt -s extglob
uuid=
listen_blk() {
	uuid=$(lsblk --json -o UUID,TRAN,TYPE,MOUNTPOINT | jq '.blockdevices[]| select(.tran == "usb").uuid')
	printf '%s\n' "Reading udev events"
}

copy_to_usb() {
	local destination="$1"
	find ~ -type d,l,f -path '*/.*' -prune -o -not -path '.*' -print | gzip >"$destination"
}
main() {
	declare -A arr
	listen_blk
	# set up event loop
	# Check block devices with tran==usb, then after 12s if user doesnt insert usb stop
	start=$EPOCHSECONDS
	while true; do
		printf '%s\n' "Insert USB device to copy to"
		if ((EPOCHSECONDS - start > 20)); then
			printf '%s' "Destination ${arr["partition"]}"
			echo copy_to_usb "/dev/disk/by-id/$uuid"
			echo sync
			echo notify-send "copied to USB"
			continue
		else
			break && printf '%s\n' " user didnt insert usb"
		fi
	done

}

main
shopt -u extglob
