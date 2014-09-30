#!/bin/bash
# Shutdown all nodes in a cluster

for node in $(crowbar machines list); do
    OUTPUT=`crowbar machines show $node roles | grep \"crowbar\"`
    
    if [ -z "$OUTPUT" ]; then
        ssh $node halt -p
        if [[ $? == "0" ]];  then
            STATUS="$(tput setaf 2)done$(tput sgr0)"
        else
            STATUS="$(tput setaf 1)error$(tput sgr0)"
        fi

        echo "[$STATUS] Shutting down node $node"
    fi
done
