#!/bin/bash

source docker.lib.sh

docker__build_if_necessary \
    mattrix/teamcity-base \
    teamcity-shared/1-teamcity-base.dock || exit 1

docker__build_if_necessary \
    mattrix/teamcity-server-depends \
    teamcity-server/1-teamcity-server-depends.dock || exit 1

docker__build_if_necessary \
    mattrix/teamcity-server \
    teamcity-server/2-teamcity-server.dock || exit 1

docker run mattrix/teamcity-server & disown
