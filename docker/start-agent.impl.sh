#!/bin/bash -x

readonly HOST_BASE_DIR="/data/teamcity-agent"
readonly HOST_SHARE_DIR="/data/teamcity-shared"
readonly HOST_LOCAL_DIR="/root/.data"

readonly CONT_DATA_DIR="/root/.BuildServer"
readonly HOST_DATA_DIR="${HOST_BASE_DIR}${CONT_DATA_DIR}"
[ -d "$HOST_DATA_DIR" ] || mkdir -p "$HOST_DATA_DIR"

readonly CONT_WORK_DIR="/usr/local/TeamCity/buildAgent/work"
readonly HOST_WORK_DIR="${HOST_BASE_DIR}${CONT_WORK_DIR}"
[ -d "$HOST_WORK_DIR" ] || mkdir -p "$HOST_WORK_DIR"

readonly CONT_CONF_DIR="/usr/local/TeamCity/buildAgent/conf/persist"
readonly HOST_CONF_DIR="${HOST_BASE_DIR}${CONT_CONF_DIR}"
[ -d "$HOST_CONF_DIR" ] || mkdir -p "$HOST_CONF_DIR"

readonly CONT_SSH_DIR="/root/.ssh"
readonly HOST_SSH_DIR="${HOST_SHARE_DIR}${CONT_SSH_DIR}"
[ -d "$HOST_SSH_DIR"  ] || mkdir -p "$HOST_SSH_DIR"

readonly CONT_DOCK_DIR="/var/lib/docker"
readonly HOST_DOCK_DIR="${HOST_LOCAL_DIR}${CONT_DOCK_DIR}"
[ -d "$HOST_DOCK_DIR" ] || mkdir -p "$HOST_DOCK_DIR"

docker_host_ip=$1
docker_host_tc_agent=$2

if ! docker start teamcity-agent 2> /dev/null
then
    source docker.lib.sh

    docker__build \
        mattrix/teamcity-base \
        teamcity-shared/1-teamcity-base/Dockerfile || exit $?

    docker__build \
        mattrix/teamcity-java \
        teamcity-shared/2-teamcity-java/Dockerfile || exit $?

    cp -v "$(which docker)" teamcity-agent/1-teamcity-agent-dind/

    docker__build \
        mattrix/teamcity-agent-dind \
        teamcity-agent/1-teamcity-agent-dind/Dockerfile || exit $?

    docker__build \
        mattrix/teamcity-agent \
        teamcity-agent/2-teamcity-agent/Dockerfile || exit $?

    docker run -d -privileged \
        -name teamcity-agent \
        -link teamcity-server:master \
        -p $docker_host_tc_agent:$docker_host_tc_agent \
        -v $HOST_DATA_DIR:$CONT_DATA_DIR \
        -v $HOST_WORK_DIR:$CONT_WORK_DIR \
        -v $HOST_SSH_DIR:$CONT_SSH_DIR \
        -v $HOST_CONF_DIR:$CONT_CONF_DIR \
        -v $HOST_DOCK_DIR:$CONT_DOCK_DIR \
        mattrix/teamcity-agent \
            "${docker_host_ip}" \
            "${docker_host_tc_agent}"
fi
