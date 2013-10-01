#!/bin/bash -x
#
# Heavily inspired by: https://github.com/Diggs/docker-teamcity-agent/blob/master/agent.sh

# Ensure all the settings are appropriate for running docker-in-docker
bash -x /usr/local/bin/wrapdocker.sh

agent_config_file=$TEAM_CITY_INSTALL_DIR/TeamCity/buildAgent/conf/buildAgent.properties
auth_token_file=$TEAM_CITY_INSTALL_DIR/TeamCity/buildAgent/conf/persist/agentId

docker_host_ip="$1"
docker_host_tc_server="$2"
docker_host_tc_agent="$3"

server_url="http://${docker_host_ip}:${docker_host_tc_server}"
own_address="${docker_host_ip}"
own_port="${docker_host_tc_agent}"

[ -r "$auth_token_file" ] && auth_token=$(cat "$auth_token_file") || auth_token=

sed -r -i.bak \
    -e "s@^#?(serverUrl=).*@\1${server_url}@g" \
    -e "s@^#?(ownAddress=).*@\1${own_address}@g" \
    -e "s@^#?(ownPort=).*@\1${own_port}@g" \
    -e "s@^#?(authorizationToken=).*@\1${auth_token}@g" \
    "$agent_config_file"

cat "$agent_config_file"

function get_token() {
    sed -r -n -e 's/^authorizationToken=([[:xdigit:]]+)[[:space:]]*.*$/\1/p' "$agent_config_file"
}

function monitor_token() {
    local token=$(get_token)

    while [ -z "$token" ]; do
        sleep 1
        token=$(get_token)
    done

    echo "$token" > "$auth_token_file"
}

# Monitor token if necessary
[ -r "$auth_token_file" ] || monitor_token & disown

$TEAM_CITY_INSTALL_DIR/TeamCity/buildAgent/bin/agent.sh run
