#!/bin/bash

host_gateway="host-gateway"
derived_host_docker_internal=$(docker network inspect bridge | jq -r ".[0].IPAM.Config[0].Gateway")
hostname_ip=$(getent hosts ${HOSTNAME} | awk '{ print $1 }')

for ipaddr in ${host_gateway} ${derived_host_docker_internal} ${hostname_ip}; do
    echo "Starting nc listener on host side, listening on 0.0.0.0:9999"
    nc -l 0.0.0.0 9999 &
    ncpid=$!

    echo "Running nc talker in container - talking to ${ipaddr}:9999"
    docker run -d --name=junk --add-host host.docker.internal:${ipaddr} drud/ddev-webserver:v1.18.0 bash -c 'echo "Hello from inside the container" | nc host.docker.internal 9999' >/dev/null
    echo
    echo "Sleeping: We should have just now seen 'Hello from inside the container'"
    sleep 3 && kill ${ncpid} && docker rm -f junk >/dev/null
done