#!/bin/bash
# Shutdown chef-client on all nodes in the cloud

for node_hostname in $(crowbar machines list); do
    echo -n "Stoping chef-client on $node_hostname..."
    ssh $node_hostname rcchef-client stop
    if [[ $? == "0" ]]; then
        echo "done"
    else
        echo "ERROR"
    fi
done
