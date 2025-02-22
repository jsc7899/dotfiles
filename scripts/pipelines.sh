#!/usr/bin/env bash

# get the total size of all files older than 7d
find . -type f -mtime +7 -exec ls -lh {} \; | tail -n +2 | awk '{print $5}' | numfmt --from=iec | awk '{sum+=1$1} END {print sum}' | numfmt --to=iec

# pull all chomp podman images
find /opt/chomp -name 'Dockerfile' | parallel 'podman pull void-registry.infosec.utexas.edu/utexasiso-$(basename $(dirname {})):production'

# list all docker registry images
curl -s https://void-registry.infosec.utexas.edu/v2/_catalog | jq '.repositories[]'
curl -s https://void-registry.infosec.utexas.edu/v2/_catalog | jq -r '.repositories[] | select(startswith("utexasiso-")) | sub("^utexasiso-"; "")'
