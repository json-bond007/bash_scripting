#!/bin/env bash

cat "$0" | sed 's/cat.*//g' >"file.txt"

echo "test"
