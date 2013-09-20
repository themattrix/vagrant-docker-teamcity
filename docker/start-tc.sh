#!/bin/bash -x

# Change directory to the one this script is in
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Include the necessary libraries
sudo bash "start-tc.impl.sh"
