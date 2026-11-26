#!/usr/bin/env bash

# From : https://stackoverflow.com/questions/1362298/convert-floating-point-variable-to-integer
floor() {
	float_in=$1
	floor_val=${float_in/.*/}
}

ceiling() {
	float_in=$1
	ceil_val=${float_in/.*/}
	ceil_val=$((ceil_val + 1))
}
