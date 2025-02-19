#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
	echo "Usage: $0 <job> <number of jobs>"
	exit 1
fi

# nomad namespace
NAMESPACE="chomp"
# job string
JOB=$1
# max jobs to kill
NUM_JOBS=$2
# number of parallel threads
THREADS=32

echo killing "$NUM_JOBS" jobs matching string "'$JOB'" in namespace "'$NAMESPACE'" with "$THREADS" parallel threads...

# Create a stop payload file
STOP_PAYLOAD=$(mktemp)
echo '{"type":"stop"}' >"$STOP_PAYLOAD"

# Function to stop jobs using dispatch
stop_job() {
	local job_id=$1
	nomad job dispatch -namespace "$NAMESPACE" "$job_id" "$STOP_PAYLOAD"
}

export -f stop_job

nomad job status -namespace "$NAMESPACE" | # get the jobs
	grep "$JOB" |                             # search for your specific job
	awk -F " " '{print $1}' |                 # print the first column which is the job ID
	shuf -n "$NUM_JOBS" |
	parallel -j$THREADS -- "echo {}; nomad job stop -namespace $NAMESPACE -detach {}"
echo stopped all jobs
echo garbage collecting and reconciling summaries...
nomad system gc
nomad system reconcile summaries

echo done!
