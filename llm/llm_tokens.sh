#!/usr/bin/env bash
set -euo pipefail

input="$*"
in_count=$(ttok "$input")
output=$(llm -m 4o-mini "$input")
out_count=$(ttok "$output")

echo -e "\n\033[31m$output\033[0m"
echo -e "\n---\nInput: $in_count tokens\nOutput: $out_count tokens"
