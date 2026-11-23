#!/usr/bin/env bash
x=2
letters=(a b c d)
main() {

	elem2=$1"[2]"
	echo ${!elem2}
}
main letters
