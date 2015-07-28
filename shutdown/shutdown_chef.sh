#!/bin/bash
# Shutdown chef-client on all nodes in the cloud
#
# exit status greater than 0: something went wrong

FILEDIR=$(dirname ${BASH_SOURCE[0]})
. $FILEDIR/includes.sh

crowbar_inst_check

for node in $(crowbar machines list); do
    if crowbar machines show $node roles | grep -q crowbar; then
        rcchef-client stop > /dev/null 2>&1
        EXIT=$?
    else
        ssh $node "rcchef-client stop > /dev/null"
        EXIT=$?
    fi

    check_exit_code $EXIT 0

    echo "[$STATUS] Stopping chef-client on node $node"
    if [ $EXIT -gt 0 ]; then
        exit $EXIT
    fi
done
