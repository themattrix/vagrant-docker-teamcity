Vagrant-Docker-TeamCity
===============================================================================

This project allows you to easily spin up a
[TeamCity](http://www.jetbrains.com/teamcity/) master and one agent, both
running in the same VM. The master and agent instances are isolated with the
use of [Docker](https://www.docker.io/) containers.


Motivation
-------------------------------------------------------------------------------

I wanted a simple and repeatable way to spin up a local
[continuous integration](http://en.wikipedia.org/wiki/Continuous_integration)
server in both Windows and OS X. It should work on any system having the
prerequisites listed below.


Prerequisites
-------------------------------------------------------------------------------

- [Virtualbox](https://www.virtualbox.org/)
- [Vagrant](http://www.vagrantup.com/)


How to Use
-------------------------------------------------------------------------------

```
$ git clone https://github.com/themattrix/vagrant-docker-teamcity.git
$ cd vagrant-docker-teamcity
$ ./bootstrap.sh
```

After the bootstrapping process has completed, open a web browser and visit
`http://localhost:8111` to connect to the TeamCity master. If this is the first
time you're connecting, you'll be asked to accept the license agreement and
start the initial setup. Note that the TeamCity agent must also be manually
registered with the master the first time.

The `bootstrap.sh` script is only required the first time. After that, simply
use:

```
$ vagrant up
```


Data Retention
-------------------------------------------------------------------------------

All of the critical TeamCity data is stored in `vagrant-docker-teamcity/.data`.
This data is stored outside of the VM so that it persists even when the VM is
destroyed.

> Note that this relies on `/vagrant` being mounted external to the VM. This is the default case for the VirtualBox provider (so long as the VirtualBox Guest Additions are installed in the VM).


Planned Future Improvements
-------------------------------------------------------------------------------

- There should be an option to upgrade to the latest TeamCity version during
  initial provisioning. Right now the TeamCity version is fixed.
