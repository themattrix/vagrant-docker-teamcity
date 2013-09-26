#!/bin/bash

INITIAL_RUN=true vagrant up || exit 1
vagrant reload --provision
