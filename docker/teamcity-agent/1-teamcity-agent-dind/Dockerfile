FROM mattrix/teamcity-java

# Heavily inspired from: https://github.com/jpetazzo/dind

RUN apt-get install -qqy iptables ca-certificates lxc

ADD docker /usr/local/bin/docker

ADD ./wrapdocker.sh /usr/local/bin/wrapdocker.sh

RUN chmod +x /usr/local/bin/docker /usr/local/bin/wrapdocker.sh

VOLUME /var/lib/docker
