#!/bin/bash -x

### Include guard

[ -n "$_DOCKER_LIB" ] && return || readonly _DOCKER_LIB=1


### Public functions

function docker__build_if_necessary() {
    local tag=$1
    local dockerfile=$2

    # If the tag doesn't exist, build it from the specified dockerfile.
    if ! docker inspect "$tag" 2> /dev/null | grep -s -q '"id"'; then
        (cd "$(dirname "$dockerfile")"; docker build -t "$tag" .)
    fi
}

function docker__get_host_ip() {
    ip -f inet addr show docker0 | sed -r -n -e '/inet/{s@.*inet ([0-9.]+)/.*@\1@p}'
}
