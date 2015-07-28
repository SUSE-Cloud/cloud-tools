#!/bin/bash
# shutdown pacemaker on each node
#
# exit status greater than 0: something went wrong

FILEDIR=$(dirname ${BASH_SOURCE[0]})
. $FILEDIR/includes.sh

crowbar_inst_check

for node in $(crowbar machines list); do
    if crowbar machines show $node roles | grep -q pacemaker-cluster-member; then
        echo -n "Shutdown pacemaker on node $node: "
        ssh $node "rcopenais stop"
        EXIT=$?

        if [[ $EXIT == "0" ]]; then
            STATUS="$(tput setaf 2)done$(tput sgr0)"
        else
            STATUS="$(tput setaf 1)error$(tput sgr0)"
        fi

        echo "[$STATUS] Stopping Pacemaker on node $node"
        if [ $EXIT -gt 0 ]; then
            exit $EXIT
        fi
    fi
done
