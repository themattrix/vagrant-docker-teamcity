#!/bin/bash -x
#
# Heavily inspired by: https://github.com/Diggs/docker-teamcity-agent/blob/master/agent.sh

# Ensure all the settings are appropriate for running docker-in-docker
bash -x /usr/local/bin/wrapdocker.sh

agent_config=$TEAM_CITY_INSTALL_DIR/TeamCity/buildAgent/conf/buildAgent.properties

docker_host_ip="$1"
docker_host_tc_server="$2"
docker_host_tc_agent="$3"

server_url="http://${docker_host_ip}:${docker_host_tc_server}"
own_address="${docker_host_ip}"
own_port="${docker_host_tc_agent}"

sed -r -i.bak \
    -e "s@^#?(serverUrl=).*@\1${server_url}@g" \
    -e "s@^#?(ownAddress=).*@\1${own_address}@g" \
    -e "s@^#?(ownPort=).*@\1${own_port}@g" \
    "$agent_config"

$TEAM_CITY_INSTALL_DIR/TeamCity/buildAgent/bin/agent.sh run
