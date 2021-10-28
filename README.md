# Gitpod host.docker.internal exploration/bug repro

This repo is just to demonstrate how one can and cannot use host.docker.internal.

In docker v20.10, you're supposed to be able to provide the address of the host
by using `extra_hosts host.docker.internal:host-gateway`, and this works on 
regular Linux, for example Ubuntu 20.04.

But neither that approach nor using `docker network inspect` to get the gateway
works in gitpod (but it works everywhere else in the world).

The script try-host-docker-internal.sh shows 3 different ways of providing `host.docker.internal` 
to the container. The first two (host-gateway and docker-network-inspected gateway value) should work
on any docker 20.10+ system and don't work at all on Gitpod. 

The third, derived by trial and error, uses the IP address associated with the host-side hostname.
And it works, but is unrelated to any technique that is documented for docker.

Note that one characteristic of Gitpod is that the `docker0` interface does not exist in `ip a`.
On every other Linux system running docker I've inspected, `docker0` is a valid interface. That includes
many varieties and distros, and it also includes GitHub Codespaces.