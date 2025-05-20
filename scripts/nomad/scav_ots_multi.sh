#!/usr/bin/env bash

# Path to the file containing the srcip and port pairs
file="targets.txt"

# Loop through each line of the file
while read -r srcip port; do
    ./scav_ots_manual.sh "$srcip" "$port"
done <"$file"
