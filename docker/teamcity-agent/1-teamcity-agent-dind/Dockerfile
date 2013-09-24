FROM mattrix/teamcity-base

# Heavily inspired from: https://github.com/jpetazzo/dind

RUN echo deb http://archive.ubuntu.com/ubuntu precise universe > /etc/apt/sources.list.d/universe.list

# Stops LXC from complaining that it cannot connect to Upstart per:
# https://github.com/dotcloud/docker/issues/1024#issuecomment-20018600
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -s /bin/true /sbin/initctl

RUN apt-get update -qq
RUN apt-get install -qqy iptables ca-certificates lxc

ADD docker /usr/local/bin/docker

ADD ./wrapdocker.sh /usr/local/bin/wrapdocker.sh

RUN chmod +x /usr/local/bin/docker /usr/local/bin/wrapdocker.sh

VOLUME /var/lib/docker
