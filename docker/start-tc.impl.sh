#!/bin/bash

#######################                   #######################
##                   ##                   ##                   ##
## TC Server == 8111 == S <<<<<<<<<<<<<<<<<<<<<<<<<<<\         ##
##          \>>>>>>>>>>>>>>>>>>>>>>>>>> A == 9090 === TC Agent ##
##                   ##                   ##                   ##
#######################                   #######################

readonly VAGRANT_TC_SERVER_LISTEN=50384

source docker.lib.sh
docker_host_ip=$(docker__get_host_ip)

source start-server.impl.sh
docker_host_tc_server=$(docker__get_port 8111)

# TODO
#source start-agent.impl.sh
#docker_host_tc_agent=$(docker__get_port 9090)

socat TCP4-LISTEN:$VAGRANT_TC_SERVER_LISTEN,fork \
      TCP4:localhost:$docker_host_tc_server \
    & disown
