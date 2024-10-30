#!/bin/bash

# Check if job name is passed as argument
if [ -z "$1" ]; then
    echo "Usage: $0 <job_name>"
    exit 1
fi

JOB_NAME=$1
NAMESPACE="${2:-chomp}"

# Get a list of all jobs matching the job name
JOBS=$(nomad job status -namespace "$NAMESPACE" | grep "$JOB_NAME" | awk '{print $1}')

# Check if any jobs were found
if [ -z "$JOBS" ]; then
    echo "No jobs found with name: $JOB_NAME"
    exit 0
fi

# Stop each job
for JOB in $JOBS; do
    echo "Stopping job: $JOB"
    nomad job stop "$JOB"
done

echo "All jobs with name $JOB_NAME have been stopped."
