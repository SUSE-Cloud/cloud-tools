#!/bin/bash
# Just a helper to copy files on all nodes in a cluster if desired so

for node in $(crowbar machines list); do
    scp $1 root@$node:~
    if [[ $? == "0" ]]; then
        echo "done"
    else
        echo "ERROR"
    fi
done
