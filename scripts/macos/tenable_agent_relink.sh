#!/usr/bin/env bash
set -euo pipefail

# unlink
echo "unlinking agent"
sudo /Library/NessusAgent/run/sbin/nessuscli agent unlink

echo "removing tenable_tag"
sudo rm /private/etc/tenable_tag

echo "relinking agent"
sudo /Library/NessusAgent/run/sbin/nessuscli agent link --host="nessus-manager.security.utexas.edu" --port="8834" --groups="INFS" --offline-install --key="2bf323d37ea6f2eb0fde001ecfa77a6ad3b41e24200ff25bf77916c39f156ec4"

echo "successfully linked agent"
sudo /Library/NessusAgent/run/sbin/nessuscli agent status
