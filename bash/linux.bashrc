#!/usr/bin/env bash

# linux
alias test_ots_net='sudo podman run -it --rm --network=ots_network --dns=1.1.1.1 --cap-add=NET_RAW -v /opt/chomp:/opt/chomp:ro -v /opt/chompout:/opt/chompout:rw void-registry.infosec.utexas.edu/utexasiso-scavenger:production curl ifconfig.me'
alias test_cluster_net='sudo podman run -it --rm --network=cluster_network --cap-add=NET_RAW -v /opt/chomp:/opt/chomp:ro -v /opt/chompout:/opt/chompout:rw void-registry.infosec.utexas.edu/utexasiso-scavenger:production ping -c1 128.83.185.40'
