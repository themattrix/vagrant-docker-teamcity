#!/bin/bash -x

source docker.lib.sh

readonly HOST_BASE_DIR="/data/teamcity-server"
readonly HOST_SHARE_DIR="/data/teamcity-shared"

readonly CONT_DATA_DIR="/root/.BuildServer"
readonly HOST_DATA_DIR="${HOST_BASE_DIR}${CONT_DATA_DIR}"

readonly CONT_SSH_DIR="/root/.ssh"
readonly HOST_SSH_DIR="${HOST_SHARE_DIR}${CONT_SSH_DIR}"

# Create non-existant directories on the host
[ -d "$HOST_DATA_DIR" ] || mkdir -p "$HOST_DATA_DIR"
[ -d "$HOST_SSH_DIR"  ] || mkdir -p "$HOST_SSH_DIR"

if ! docker start teamcity-server 2> /dev/null
then
    docker__build \
        mattrix/teamcity-base \
        teamcity-shared/1-teamcity-base/Dockerfile || exit $?

    docker__build \
        mattrix/teamcity-java \
        teamcity-shared/2-teamcity-java/Dockerfile || exit $?

    docker__build \
        mattrix/teamcity-server \
        teamcity-server/1-teamcity-server/Dockerfile || exit $?

    docker run -d \
        -name teamcity-server \
        -p 8111:8111 \
        -v $HOST_DATA_DIR:$CONT_DATA_DIR \
        -v $HOST_SSH_DIR:$CONT_SSH_DIR \
        mattrix/teamcity-server
fi
