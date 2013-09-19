#!/bin/bash

# Change directory to the one this script is in
cd "$(dirname "$(which "$0")")"

# Include the necessary libraries
sudo bash start-tc.impl.sh
