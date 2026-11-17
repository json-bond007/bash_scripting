#!/usr/bin/env bash

# Quick and dirty menu, Exercise:
# # Exercise:
# --------
# Change the script so it accepts multiple inputs,
#+ instead of terminating after displaying just one address.
clear
while true; do
	echo "  Contact List  "
	echo "  ------------  "
	echo " Choose one of the following "
	echo " Persons  "
	echo " [E]vans, Roland"
	echo " [J]ones, Mildread"
	echo " [S]mith, Julie"
	echo " [Z]ane, Morris"

	while read person; do

		case "$person" in
		"E" | "e")
			echo
			echo " Roland Evans "
			echo "--------------"
			echo " Hardscrabble, CO 80753 "
			echo " (303) 734-9874 "
			;;
		"J" | "j")
			echo
			echo " Mildred Jones "
			echo "240 E 7th St., Apt. 19"
			echo " (212) 533-2814 "
			echo " Ex-girlfriend "
			;;
		*)
			echo
			echo " No yet in database"
			;;
		esac
	done
done
