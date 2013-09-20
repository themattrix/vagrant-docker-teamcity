FROM mattrix/teamcity-base

# Heavily inspired from: https://github.com/jpetazzo/dind

RUN echo deb http://archive.ubuntu.com/ubuntu precise universe > /etc/apt/sources.list.d/universe.list

RUN apt-get update -qq
RUN apt-get install -qqy iptables ca-certificates lxc

# This will use the latest public release. To use your own, comment it out...
ADD https://get.docker.io/builds/Linux/x86_64/docker-latest /usr/local/bin/docker
# ...then uncomment the following line, and copy your docker binary to current dir.
#ADD /usr/bin/docker /usr/local/bin/docker

ADD ./wrapdocker.sh /usr/local/bin/wrapdocker.sh

RUN chmod +x /usr/local/bin/docker /usr/local/bin/wrapdocker.sh

VOLUME /var/lib/docker
