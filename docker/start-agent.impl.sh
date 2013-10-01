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

readonly HOST_BASE_DIR="/vagrant/.data/teamcity-agent"
readonly HOST_SHARE_DIR="/vagrant/.data/teamcity-shared"

readonly CONT_DATA_DIR="/root/.BuildServer"
readonly HOST_DATA_DIR="${HOST_BASE_DIR}${CONT_DATA_DIR}"

readonly CONT_WORK_DIR="/usr/local/TeamCity/buildAgent/work"
readonly HOST_WORK_DIR="${HOST_BASE_DIR}${CONT_WORK_DIR}"

readonly CONT_CONF_DIR="/usr/local/TeamCity/buildAgent/conf/persist"
readonly HOST_CONF_DIR="${HOST_BASE_DIR}${CONT_CONF_DIR}"

readonly CONT_SSH_DIR="/root/.ssh"
readonly HOST_SSH_DIR="${HOST_SHARE_DIR}${CONT_SSH_DIR}"

# Create non-existant directories on the host
[ -d "$HOST_DATA_DIR" ] || mkdir -p "$HOST_DATA_DIR"
[ -d "$HOST_WORK_DIR" ] || mkdir -p "$HOST_WORK_DIR"
[ -d "$HOST_SSH_DIR"  ] || mkdir -p "$HOST_SSH_DIR"
[ -d "$HOST_CONF_DIR" ] || mkdir -p "$HOST_CONF_DIR"

docker_host_ip=$1
docker_host_tc_server=$2
docker_host_tc_agent=$3

docker run -d -privileged \
    -v $HOST_DATA_DIR:$CONT_DATA_DIR \
    -v $HOST_WORK_DIR:$CONT_WORK_DIR \
    -v $HOST_SSH_DIR:$CONT_SSH_DIR \
    -v $HOST_CONF_DIR:$CONT_CONF_DIR \
    mattrix/teamcity-agent \
        "${docker_host_ip}" \
        "${docker_host_tc_server}" \
        "${docker_host_tc_agent}"
