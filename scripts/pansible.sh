#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 -j <number_of_parallel_jobs> [ansible_playbook_options]"
    echo "  -j: Number of parallel jobs"
    echo "  ansible_playbook_options: Additional options to pass to ansible-playbook"
    exit 1
}

# Ensure at least the -j option is provided
if [[ $# -lt 2 ]]; then
    usage
fi

# Extract the -j option and value
parallel_jobs=""
ansible_options=()
while [[ $# -gt 0 ]]; do
    case "$1" in
    -j)
        if [[ -n "$2" && "$2" != -* ]]; then
            parallel_jobs=$2
            shift 2
        else
            usage
        fi
        ;;
    --)
        shift
        break
        ;;
    -*)
        ansible_options+=("$1")
        shift
        ;;
    *)
        break
        ;;
    esac
done

# Capture remaining arguments as ansible options
while [[ $# -gt 0 ]]; do
    ansible_options+=("$1")
    shift
done

# Check if the number of parallel jobs is set
if [ -z "$parallel_jobs" ]; then
    usage
fi

# Extract playbook names from site.yaml
playbooks=$(rg -oP '(?<=import_playbook: ).*' site.yaml)

# Check if any playbooks were found
if [ -z "$playbooks" ]; then
    echo "No playbooks found in site.yaml"
    exit 1
fi

# Export the list of playbooks to a temporary file
playbooks_file=$(mktemp)
echo "$playbooks" >"$playbooks_file"

# Function to clean up the temporary file
cleanup() {
    rm -f "$playbooks_file"
}
trap cleanup EXIT

# source venv
source /opt/ansible/.venv/bin/activate
# source ansible env
source /opt/ansible/setup/.env.ansible

# Run playbooks in parallel with additional arguments
cat "$playbooks_file" | parallel -j "$parallel_jobs" ansible-playbook {} -e "ansible_become_pass='{{ ansible_user_passwd }}'" "${ansible_options[@]}"
