#!/bin/bash -x

source docker.lib.sh

docker__build_if_necessary \
    mattrix/teamcity-base \
    teamcity-shared/1-teamcity-base/Dockerfile || exit 1

docker__build_if_necessary \
    mattrix/teamcity-server-depends \
    teamcity-server/1-teamcity-server-depends/Dockerfile || exit 1

docker__build_if_necessary \
    mattrix/teamcity-server \
    teamcity-server/2-teamcity-server/Dockerfile || exit 1

docker run -d mattrix/teamcity-server
