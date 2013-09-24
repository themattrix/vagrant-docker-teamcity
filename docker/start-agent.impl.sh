#!/bin/bash -x

source docker.lib.sh

docker__build_if_necessary \
    mattrix/teamcity-base \
    teamcity-shared/1-teamcity-base/Dockerfile || exit 1

cp -v "$(which docker)" teamcity-agent/1-teamcity-agent-dind/

docker__build_if_necessary \
    mattrix/teamcity-agent-dind \
    teamcity-agent/1-teamcity-agent-dind/Dockerfile || exit 1

docker__build_if_necessary \
    mattrix/teamcity-agent-depends \
    teamcity-agent/2-teamcity-agent-depends/Dockerfile || exit 1

docker__build_if_necessary \
    mattrix/teamcity-agent \
    teamcity-agent/3-teamcity-agent/Dockerfile || exit 1

docker_host_ip=$1
docker_host_tc_server=$2
docker_host_tc_agent=$3

# Use the Google DNS as a workaround to this issue:
# https://github.com/dotcloud/docker/issues/1502
docker run -d -privileged -dns 8.8.8.8 mattrix/teamcity-agent \
    "${docker_host_ip}" \
    "${docker_host_tc_server}" \
    "${docker_host_tc_agent}"
