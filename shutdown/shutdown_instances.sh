#!/bin/bash
# Shutdown all instances in a cloud - untested, probably not fully working

if [ -f "~/.openrc" ]; then
    . ~/.openrc
fi

for tenant_id in $(keystone tenant-list | grep -v ' service ' | tail -n +4 | head -n -1 | cut -d'|' -f2); do
    for server_id in $(nova --os-tenant-id "$tenant_id" list | grep -v PAUSED | tail -n +4 | head -n -1 | cut -d'|' -f2); do
        echo -n "Pausing $server_id (tenant $tenant_id)..."
        nova --os-tenant-id pause $tenant_id $server_id
        if [[ $? == "0" ]]; then
            echo "done"
        else
            echo "ERROR"
        fi
    done
done
