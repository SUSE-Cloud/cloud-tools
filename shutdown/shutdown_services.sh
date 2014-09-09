#!/bin/bash
# Disable all openstack services on all nodes

for node in $(crowbar machines list) ; do
   echo "Disabling OpenStack services on ${node}..."
   ssh "$node" 'rcchef-client stop; if ls /etc/init.d/openstack-* &>/dev/null; then for i in /etc/init.d/openstack-*; do initscript=`basename $i`; chkconfig -d $initscript; $i stop; done; fi'
done
