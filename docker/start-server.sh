#!/bin/bash

# Change directory to the one this script is in
cd "$(dirname "$(which "$0")")"

# Run the server implementation script
sudo bash start-server.impl.sh
