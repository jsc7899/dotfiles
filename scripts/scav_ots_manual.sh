#!/bin/bash

export NOMAD_ADDR="http://nomad-server-1:4646"

# Function to create the modified JSON
generate_json() {
  local srcip="$1"
  local port="$2"

  cat <<EOF
{
  "exclude": "127.0.0.1",
  "target": "$srcip",
  "directives": "-Pn -n -sV -p$port",
  "org": "utsystem.utexas.activeip",
  "scan_net": "ots_network",
  "rex": "bnVsbA==",
  "scan_name": "Manual",
  "scan_size": "32",
  "use_list": "True"
}
EOF
}

# Function to base64 encode the data
encode_base64() {
  local data="$1"
  echo "$data" | base64
}

# Check if correct number of arguments provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <srcip> <port>"
  exit 1
fi

# Get srcip and port from command line arguments
srcip="$1"
port="$2"

# Generate JSON with provided srcip and port
json_data=$(generate_json "$srcip" "$port")

# Base64 encode the JSON data
base64_data=$(encode_base64 "$json_data")

# Nomad job dispatch command with meta key "blob" equal to base64 encoded data
nomad job dispatch -namespace chomp -meta "blob=$base64_data" scavenger-ots_network

# Output the generated base64 data for reference
echo -e "\nBase64 Encoded JSON Data:"
echo "$base64_data"
