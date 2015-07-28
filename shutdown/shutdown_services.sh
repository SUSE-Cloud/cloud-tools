#!/bin/bash
# Disable all openstack services on all nodes

FILEDIR=$(dirname ${BASH_SOURCE[0]})
. $FILEDIR/includes.sh

crowbar_inst_check

# shutdown neutron-l3
for node in $(crowbar machines list); do
    if crowbar machines show $node roles | grep -q neutron-l3; then
        ssh $node "rcopenstack-neutron-l3-agent stop > /dev/null"
        EXIT=$?

        if [[ $EXIT == "0" ]]; then
            STATUS="${GREEN}done${RESET}"
        else
            STATUS="${RED}error${RESET}"
        fi

        echo "[$STATUS] Stopping neutron-l3 agent on node $node"
        if [ "$EXIT" != "0" ]; then
            exit $EXIT
        fi
    fi
done

# shutdown all openstack services
for node in $(crowbar machines list) ; do
    if crowbar machines show $node roles | grep -q crowbar; then
        echo "Disabling OpenStack services on ${node}..."
        cat <<'SSHEOF' | ssh -T $node
        if [ ! -z "$(ls /etc/init.d | grep openstack-)" ]; then
            if [ "ls /etc/init.d/openstack-*" != "" ]; then
                for i in /etc/init.d/openstack-*; do
                    chkconfig -d $(basename $i) > /dev/null
                    $i stop
                done
            fi
        fi
SSHEOF
    fi
done

# shutdown database
for node in $(crowbar machines list); do
    if crowbar machines show $node roles | grep -q database-server; then
        ssh $node "rcpostgresql stop > /dev/null"
        if [[ $EXIT == "0" ]]; then
            STATUS="${GREEN}done${RESET}"
        else
            STATUS="${RED}error${RESET}"
        fi

        echo "[$STATUS] Stopping database on node $node"
        if [ "$EXIT" != "0" ]; then
            exit $EXIT
        fi
    fi
done

# shutdown rabbitmq
for node in $(crowbar machines list); do
    if crowbar machines show $node roles | grep -q rabbitmq-server; then
        ssh $node "rcrabbitmq-server stop > /dev/null"
        if [[ $EXIT == "0" ]]; then
            STATUS="${GREEN}done${RESET}"
        else
            STATUS="${RED}error${RESET}"
        fi

        echo "[$STATUS] Stopping rabbitmq server on node $node"
        if [ "$EXIT" != "0" ]; then
            exit $EXIT
        fi
    fi
done
