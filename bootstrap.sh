#!/bin/bash

echo
echo "####################################################################"
echo "##                                                                ##"
echo "##                    Ensuring Vagrant Plugins                    ##"
echo "##                                                                ##"
echo "####################################################################"
echo

vagrant plugin install vagrant-vbguest || exit $?

echo
echo "####################################################################"
echo "##                                                                ##"
echo "##                       Bootstrapping VM                         ##"
echo "##                                                                ##"
echo "####################################################################"
echo

# Update kernel, download VBoxGuestAdditions, and reboot
INITIAL_RUN=true vagrant up --provision || exit $?

echo
echo "####################################################################"
echo "##                                                                ##"
echo "##                      Normal Provisioning                       ##"
echo "##                                                                ##"
echo "####################################################################"
echo

# Reboot a final time (without any special flags this time) and run normal provisioning
vagrant reload --provision
