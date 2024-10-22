#!/usr/bin/env bash

set -euo pipefail

# Ensure the script is executed with an address (IP or MAC) argument or input file from stdin
if [ "$#" -ne 2 ] && [ -t 0 ]; then
  echo "Usage: $0 <ACTION> <ADDRESS> or provide newline-separated list via stdin"
  exit 1
fi

# Load the API key from the configuration file
API_KEY=$(grep "XMP_APIKEY" /opt/chomp/secret/xmp.conf | awk -F'=' '{print $2}' | xargs)
if [ -z "$API_KEY" ]; then
  echo "API key not found. Please check your configuration file."
  exit 1
fi

API_BQ_URL="https://xmp-api.gw.utexas.edu/api/quarantine"

# Function to check response and handle output
parse_check_resp() {
  local resp_code="$(echo "$RESPONSE" | jq -r '.statusCode')"

  if [[ $resp_code == 200 ]]; then
    local data="$(echo "$RESPONSE" | jq -r '.data[]')"
    local date=$(echo "$data" | jq -r '.effectiveUTC')
    echo "$ADDRESS bq'd since: $(date -r "$date" +"%Y-%m-%dT%H:%M:%S%z")"
  else
    echo "$(echo "$RESPONSE" | jq -r '.statusText') found for ADDRESS: $ADDRESS"
  fi
}

# check mac bqs
check_current_bq() {
  local api_url="${API_BQ_URL}/MAC/${ADDRESS}"
  RESPONSE=$(curl -s -H "XMPAPIKEY: ${API_KEY}" "${api_url}")
  parse_check_resp
}

check_future_bq() {
  local api_url="${API_BQ_URL}/MACfuture/${ADDRESS}"
  RESPONSE=$(curl -s -H "XMPAPIKEY: ${API_KEY}" "${api_url}")
}

# clear mac bqs
clear_current_bq() {
  echo "clearing $ADDRESS"
  local api_url="${API_BQ_URL}/MAC/${ADDRESS}"
  RESPONSE=$(curl -s -X DELETE -H "XMPAPIKEY: ${API_KEY}" "${api_url}")
  echo "$RESPONSE" | jq -r '.statusText'
}

clear_future_bq() {
  local api_url="${API_BQ_URL}/MACfuture/${ADDRESS}"
  RESPONSE=$(curl -s -X DELETE -H "XMPAPIKEY: ${API_KEY}" "${api_url}")
  parse_check_resp
}

ACTION="$1"
if [[ "$ACTION" == "check" ]]; then
  func=check_current_bq
elif [[ "$ACTION" == "clear" ]]; then
  func=clear_current_bq
else
  echo "not a valid action"
  exit 1
fi

# Check if input is provided via stdin or as a CLI argument
if [ -t 0 ]; then
  # If a single argument is provided via CLI
  ADDRESS="$2"
  $func
else
  # If input is provided via stdin (newline-separated list)
  while IFS= read -r ADDRESS; do
    $func
  done
fi
