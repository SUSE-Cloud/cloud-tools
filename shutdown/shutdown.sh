#!/bin/bash
# this script shuts down an entire cloud
#
# exit status greater than 0: something went wrong in an executed script

FILEDIR=$(dirname ${BASH_SOURCE[0]})
. $FILEDIR/includes.sh

MAX_STEPS=6

crowbar_inst_check

# shutdown process
echo "-- Shutting down the entire cloud --"

# shutdown_instances.sh
echo "Stopping all virtual instances (1/$MAX_STEPS)"
$FILEDIR/shutdown_instances.sh
detect_error $?

# shutdown_chef.sh
echo "Stopping all chef-clients (2/$MAX_STEPS)"
$FILEDIR/shutdown_chef.sh
detect_error $?

# shutdown_pacemaker.sh
echo "Stopping Pacemaker on each node (3/$MAX_STEPS)"
$FILEDIR/shutdown_pacemaker.sh
detect_error $?

# shutdown_services.sh
echo "Shutting down all services (4/$MAX_STEPS)"
$FILEDIR/shutdown_services.sh
detect_error $?

# shutdown_nodes.sh
echo "Shutting down all nodes (5/$MAX_STEPS)"
$FILEDIR/shutdown_nodes.sh
detect_error $?

# shutdown_nodes.sh adminnode
echo "Shutting down the adminnode (6/$MAX_STEPS)"
$FILEDIR/shutdown_nodes.sh adminnode
detect_error $?
