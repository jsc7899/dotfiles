#!/bin/bash

NS=chomp

# Get all jobs
jobs=$(nomad job status -namespace $NS -short | awk '{print $1}' | grep -v "ID")

# Loop through each job and check the node pool
for job in $jobs; do
    if nomad job inspect -namespace $NS "$job" | jq -r '.Job.NodePool' | grep all; then
        echo "Job $job is using node pool 'all'"
    fi
done
