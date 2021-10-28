#!/bin/bash

echo "Starting nc listener on host side, listening on 9999"
nc -l 0.0.0.0 9999 &
ncpid=$!

echo "Running nc talker in container - talking to 9999"
docker run --add-host host.docker.internal:host-gateway drud/ddev-webserver:v1.18.0 bash -c 'echo "Hello from inside the container" | nc host.docker.internal 9999'

echo "Sleeping: We should have seen 'hello from inside'"
sleep 5 && kill ${ncpid}
