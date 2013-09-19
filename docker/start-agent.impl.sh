#!/bin/bash

source docker.lib.sh

docker__build_if_necessary \
    mattrix/teamcity-base \
    teamcity-shared/1-teamcity-base.dock || exit 1

docker__build_if_necessary \
    mattrix/teamcity-server-depends \
    teamcity-agent/1-teamcity-agent-depends.dock || exit 1

docker__build_if_necessary \
    mattrix/teamcity-server \
    teamcity-agent/2-teamcity-agent.dock || exit 1

# TODO: will eventually need to run in privileged mode
docker run mattrix/teamcity-agent & disown
