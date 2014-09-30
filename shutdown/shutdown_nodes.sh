#!/bin/bash
# Shutdown all nodes in a cluster

FILEDIR=$(dirname ${BASH_SOURCE[0]})
. $FILEDIR/includes.sh

crowbar_inst_check

TMP_FILE="/tmp/shutdown_nodes.tmp"

if [ "$1" = "adminnode" ]; then
    echo "Bye!"
    halt -p
else
    for node in $(crowbar machines list); do
        OUTPUT=`crowbar machines show $node roles | grep \"crowbar\"`
        
        if [ -z "$OUTPUT" ]; then
            ssh $node halt -p 2> $TMP_FILE
            if [[ $? == "0" ]];  then
                STATUS="${GREEN}done${RESET}"
            else
                if cat $TMP_FILE | grep -q "No route to host"; then
                    ERRORMSG=" (the node is not reachable through ssh)"
                else
                    ERROMSG=`cat $TMP_FILE`
                    EXIT=1
                fi
                STATUS="${RED}error${RESET}"
            fi

            echo "[$STATUS] Shutting down node $node$ERRORMSG"
            if [ $EXIT -eq 1 ]; then
                exit $EXIT
            fi
        fi
    done

    rm $TMP_FILE
fi
