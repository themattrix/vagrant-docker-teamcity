#!/bin/bash -x

#######################                   #######################
##                   ##                   ##                   ##
## TC Server == 8111 == 8111 <<<<<<<<<<<<<<<<<<<<<<<<\         ##
##          \>>>>>>>>>>>>>>>>>>>>>>> 9090 == 9090 === TC Agent ##
##                   ##                   ##                   ##
#######################                   #######################

source docker.lib.sh

bash start-server.impl.sh

docker_host_ip=$(docker__get_host_ip)
docker_host_tc_server=8111
docker_host_tc_agent=9090

bash start-agent.impl.sh \
    "${docker_host_ip}" \
    "${docker_host_tc_server}" \
    "${docker_host_tc_agent}"
