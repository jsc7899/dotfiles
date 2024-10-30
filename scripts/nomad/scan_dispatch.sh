#!/usr/bin/env bash
set -euo pipefail

NOMAD_ADDR=http://192.168.1.41:4646
NAMESPACE="chomp"

# Check if sufficient arguments are provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <job_name> [additional_config]"
    exit 1
fi

NOMAD_JOB="$1"
shift 1

CONFIG="$*"

# Read input from stdin
while IFS= read -r line || [[ -n "$line" ]]; do
    # Dispatch the line to the Nomad job
    echo "Dispatching line: $line with config: $CONFIG"
    nomad job dispatch -detach -address "$NOMAD_ADDR" -namespace "$NAMESPACE" -meta target="$line" -meta config="$CONFIG" "$NOMAD_JOB"

done

echo "All lines have been dispatched."
