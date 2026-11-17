#!/usr/bin//env bash

# Get command line parameters
#
case "$1" in
"-h" | "--help") echo " Usage: ${0##*/} <filenames>" ;;
"--verbose" | -v) echo "${FILENAME:-./${0##*/} $1}" ;;
"*") FILENAME=$1 ;;
esac
