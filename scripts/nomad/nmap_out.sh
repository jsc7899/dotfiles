nmap localhost -oX - |
    yq -oj -px 'del(.nmaprun.host.ports.extraports.extrareasons."+@ports", .nmaprun.scaninfo."+@services") | .nmaprun' |
    sed 's/+@//g'
