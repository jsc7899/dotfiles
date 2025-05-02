#!/bin/bash

# Define the new DNS servers
DNS_SERVERS=("192.168.2.106" "128.83.185.40" "192.168.1.24" "1.1.1.1" "128.83.185.41")

# Function to update DNS servers for a given network service
update_dns() {
    local service=$1
    local servers=("${!2}")

    # Clear existing DNS servers
    sudo networksetup -setdnsservers "$service" empty

    # Set new DNS servers
    sudo networksetup -setdnsservers "$service" "${servers[@]}"
}

# Define the network services to be updated
SERVICES=("Wi-Fi" "Ethernet")

# Loop through each service and update the DNS servers
for service in "${SERVICES[@]}"; do
    echo "Updating DNS servers for $service..."
    update_dns "$service" DNS_SERVERS[@]
done

echo "DNS servers updated successfully."

# Verify the changes
for service in "${SERVICES[@]}"; do
    echo "Current DNS servers for $service:"
    networksetup -getdnsservers "$service"
done
