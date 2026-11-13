#!/bin/env bash

# Snippet from: https://www.tutorialkart.com/bash-shell-scripting/bash-string-reverse/
s="Hello World"
strlen=${#s}
for ((i = $strlen - 1; i >= 0; i--)); do
	revstr=$revstr${s:$i:1}
done
echo "Original String : $s"
echo "Reversed String : $revstr"
