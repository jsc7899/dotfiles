#!/usr/bin/env bash
set -euo pipefail

DEFAULT_DNS_SERVER=1.1.1.1
DNS_SERVER="${1:-$DEFAULT_DNS_SERVER}"
PRIMARY_INTERFACE=$(networksetup listnetworkserviceorder | grep -o '(1) Ethernet' | awk '{print $2}')

TITLE="VPN EXIT"
MESSAGE="VPN has exited. resetting dns server to $DNS_SERVER"

if [[ $(uname) == "Darwin" ]]; then
    osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\""
fi

echo "setting DNS on interface $PRIMARY_INTERFACE to $DNS_SERVER"
sudo networksetup -setdnsservers "$PRIMARY_INTERFACE" "$DNS_SERVER"
