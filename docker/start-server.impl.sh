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

readonly HOST_BASE_DIR="/vagrant/.data/teamcity-server"
readonly HOST_SHARE_DIR="/vagrant/.data/teamcity-shared"

readonly CONT_DATA_DIR="/root/.BuildServer"
readonly HOST_DATA_DIR="${HOST_BASE_DIR}${CONT_DATA_DIR}"

readonly CONT_SSH_DIR="/root/.ssh"
readonly HOST_SSH_DIR="${HOST_SHARE_DIR}${CONT_SSH_DIR}"

# Create non-existant directories on the host
[ -d "$HOST_DATA_DIR" ] || mkdir -p "$HOST_DATA_DIR"
[ -d "$HOST_SSH_DIR"  ] || mkdir -p "$HOST_SSH_DIR"

docker run -d \
    -v $HOST_DATA_DIR:$CONT_DATA_DIR \
    -v $HOST_SSH_DIR:$CONT_SSH_DIR \
    mattrix/teamcity-server
