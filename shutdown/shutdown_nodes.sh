#!/bin/bash
# Shutdown all nodes in a cluster
# Warning: this eventually also shuts down the admin node

for node in $(crowbar machines list); do
  if [[ $node != *admin* ]] ; then
    echo "Shutting down node $node"
    ssh $node halt -p
    if [[ $? == "0" ]];  then
      echo "done"
    else
      echo "ERROR"
    fi
  fi
done
