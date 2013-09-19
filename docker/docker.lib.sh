#!/bin/bash

### Include guard

[ -n "$_DOCKER_LIB" ] && return || readonly _DOCKER_LIB=1


### Public functions

function docker__build_if_necessary() {
    local tag=$1
    local dockerfile=$2

    # If the tag doesn't exist, build it from the specified dockerfile.
    if ! docker inspect "$tag" 2> /dev/null | grep -s -q '"id"'; then
        docker build -t "$tag" - < "$dockerfile"
    fi
}

function docker__get_port() {
    local exposed_port=$1
    local docker_port=

    while true; do
        docker_port=$(docker__prv__get_port $exposed_port)
        [ -z "$docker_port" ] || break
        sleep 1
    done

    echo $docker_port
}

function docker__get_host_ip() {
    ip -f inet addr show docker0 | sed -r -n -e '/inet/{s@.*inet ([0-9.]+)/.*@\1@p}'
}


### Private functions

function docker__prv__get_port() {
    local exposed_port=$1

    # Scrape the dynamically assigned port from the output of 'docker ps'
    docker ps | sed -r -n -e "/->${exposed_port}/{s/.* ([0-9]+)->.*/\1/p}"
}
