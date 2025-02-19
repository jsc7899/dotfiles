#!/bin/bash

NAMESPACE="default"  # Default namespace if none is provided

# Function to display usage
usage() {
    echo "Usage: $0 [-n namespace]"
    echo "  -n, --namespace    Specify the Nomad namespace to target (default: 'default')"
    exit 1
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -n|--namespace)
            NAMESPACE="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown parameter: $1"
            usage
            ;;
    esac
done

# Check if Nomad CLI is installed
if ! command -v nomad &> /dev/null; then
    echo "Nomad CLI is not installed. Please install it first."
    exit 1
fi

# Get all running Nomad jobs in the specified namespace
jobs=$(nomad job status -namespace="$NAMESPACE" -short | awk '{print $1}' | grep -v "ID")

# Check if there are any jobs to stop
if [[ -z "$jobs" ]]; then
    echo "No jobs found to stop and purge in namespace '$NAMESPACE'."
    exit 0
fi

# Stop and purge each job
for job in $jobs; do
    echo "Stopping job: $job in namespace: $NAMESPACE"
    nomad job stop -detach -namespace="$NAMESPACE" -purge "$job"
    if [[ $? -ne 0 ]]; then
        echo "Failed to stop and purge job: $job in namespace: $NAMESPACE"
    else
        echo "Successfully stopped and purged job: $job in namespace: $NAMESPACE"
    fi
done

echo "All jobs in namespace '$NAMESPACE' have been stopped and purged."

