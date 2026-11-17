#!/usr/bin/env bash

# From "Stupid Script Tricks," Volume II
# Script sources itself, then increments, exits, reapeat until either kernel
# kills it or stops before 100
cat $0
MAXPASSCNT=100
let "pass_count += 1"
while [ "$pass_count" -le $MAXPASSCNT ]; do
	. $0
done
exit 0
