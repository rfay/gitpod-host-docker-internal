#!/bin/bash

sudo apt-get update >/dev/null && sudo apt-get install jq netcat >/dev/null

nc -l 0.0.0.0 9999 &
ncpid=$!

container=$(docker run -d --add-host host.docker.internal:host-gateway drud/ddev-webserver:v1.18.0 bash -c 'echo "Hello from inside the container" | nc host.docker.internal 9999')

kill $ncpid