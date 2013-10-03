#!/bin/bash

function vbox_guest_installing() {
    ssh vagrant -c 'ps ax | grep -sq [V]BoxGuestAdditions' 2> /dev/null
}

echo
echo "####################################################################"
echo "##                                                                ##"
echo "##                       Bootstrapping VM                         ##"
echo "##                                                                ##"
echo "####################################################################"
echo

# Update kernel, download VBoxGuestAdditions, and reboot
INITIAL_RUN=true vagrant up --provision || exit 1

echo
echo "####################################################################"
echo "##                                                                ##"
echo "##                 Installing VBox Guest Additions                ##"
echo "##                                                                ##"
echo "####################################################################"
echo

echo "Waiting at least 3 minutes for VirtualBox Guest Additions to install..."
sleep 180

# Don't continue until VBoxGuestAdditions is no longer running
while vbox_guest_installing; do
    sleep 1
done

echo
echo "####################################################################"
echo "##                                                                ##"
echo "##                          Provisioning                          ##"
echo "##                                                                ##"
echo "####################################################################"
echo

# Reboot a final time (without any special flags this time) and run normal provisioning
vagrant reload --provision
