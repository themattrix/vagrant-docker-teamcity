#!/bin/bash

function build_if_necessary() {
    local tag=$1
    local dockerfile=$2

    # If the tag doesn't exist, build it from the specified dockerfile.
    if ! docker inspect "$tag" 2> /dev/null | grep -s -q '"id"'; then
        docker build -t "$tag" - < "$dockerfile"
    fi
}

build_if_necessary mattrix/teamcity-server-downloaded \
    teamcity-server/1-teamcity-server-downloaded.dock || exit 1

build_if_necessary mattrix/teamcity-server-depends \
    teamcity-server/2-teamcity-server-depends.dock || exit 1

build_if_necessary mattrix/teamcity-server \
    teamcity-server/3-teamcity-server.dock || exit 1

docker run mattrix/teamcity-server & disown

# Give docker time to come up
#sleep 1

# TODO: Forward host port 50384 to docker port ?
#socat TCP4-LISTEN:50384,fork TCP4:localhost:49153 & disown
