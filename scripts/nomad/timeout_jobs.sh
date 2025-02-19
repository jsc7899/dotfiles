#!/usr/bin/env bash
set -euo pipefail

# Initialize variables
dry_run=false

# Function to display usage
usage() {
    echo "Usage: $0 <search_regex> [-n]"
    echo "  <search_regex> : A regex pattern to search for in job names."
    echo "  -n             : Perform a dry run (only print jobs that would be deleted)."
    exit 1
}

# Check if at least one argument is provided
if [[ $# -lt 1 ]]; then
    usage
fi

# Get the search string from the first argument
search_string="$1"
shift # Shift the positional arguments to handle additional options like -n

# Parse optional flags
while getopts ":n" opt; do
    case $opt in
        n)
            dry_run=true
            ;;
        *)
            usage
            ;;
    esac
done

# Get the current timestamp in seconds
current_time=$(date +%s)

# Process the input line by line
nomad job status -verbose -namespace chomp | grep -E "$search_string" | while read -r line; do
  # Extract the last field (timestamp) from the line
  timestamp=$(echo "$line" | awk '{print $NF}')

  # Convert the timestamp to seconds since epoch
  timestamp_seconds=$(date -d "$timestamp" +%s 2>/dev/null)

  # Extract the job ID (assume it's the first field in the output)
  job_id=$(echo "$line" | awk '{print $1}')

  # Check if the timestamp is valid and older than 48 hours
  if [[ -n "$timestamp_seconds" && $((current_time - timestamp_seconds)) -gt $((48 * 3600)) ]]; then
    if [[ "$dry_run" == true ]]; then
      # In dry run mode, just print the job ID and timestamp
      echo "Dry Run: Job '$job_id' would be deleted (timestamp: $timestamp)."
    else
      # In actual mode, delete the job and print a confirmation
      echo "Deleting Job: '$job_id' (timestamp: $timestamp)."
      nomad job stop -namespace chomp -detach "$job_id" || echo "Failed to delete job: $job_id"
    fi
  fi
done

