#!/usr/bin/env bash
set -euo pipefail

source /opt/chomp/secret/splunk.env
QUERY_PATH=${1:-}
if [ -z "$QUERY_PATH" ]; then
    SEARCH_QUERY=$(cat -)
else
    SEARCH_QUERY=$(cat "$QUERY_PATH")
fi
SPLUNK_URL="https://${SPLUNK_HOST}:${SPLUNK_PORT}/services/search/jobs/export"

response=$(curl -s -k -u "${SPLUNK_USER}:${SPLUNK_PASS}" "${SPLUNK_URL}" \
    --data-urlencode "search=${SEARCH_QUERY}" \
    --data "output_mode=json")

echo "${response}" | jq '.result | with_entries(select(.key == "_time" or .key == "_raw" or (.key | startswith("_") | not)))' | tee "splunkout_$(date -Iseconds).json"
