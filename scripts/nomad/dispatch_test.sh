#!/usr/bin/env bash

# Usage: ./dispatch_in_batches.sh <job_name> <total_dispatches> <batch_size> <batch_delay>

# Input parameters
job_name=$1        # The job name for the Nomad job dispatch (e.g., net_check)
total_dispatches=$2  # Total number of dispatches to send
batch_size=$3      # Number of dispatches to send per batch
batch_delay=$4     # Delay (in seconds) between batches

if [[ $# -ne 4 ]]; then
    echo "Usage: $0 <job_name> <total_dispatches> <batch_size> <batch_delay>"
    exit 1
fi

# Calculate the number of batches needed
num_batches=$(( (total_dispatches + batch_size - 1) / batch_size ))

for (( batch=1; batch<=num_batches; batch++ ))
do
    echo "Sending batch $batch of $num_batches..."

    # Calculate the number of dispatches for the current batch
    start_dispatch=$(( (batch - 1) * batch_size + 1 ))
    end_dispatch=$(( batch * batch_size ))

    # Ensure we don't exceed the total number of dispatches
    if [[ $end_dispatch -gt $total_dispatches ]]; then
        end_dispatch=$total_dispatches
    fi

    # Dispatch jobs in parallel using xargs
    seq $start_dispatch $end_dispatch | xargs -P $batch_size -I {} nomad job dispatch -detach -namespace infra "$job_name"

    # Delay before the next batch, if it's not the last batch
    if [[ $batch -lt $num_batches ]]; then
        echo "Waiting for $batch_delay seconds before the next batch..."
        sleep $batch_delay
    fi
done

echo "All dispatches completed."
