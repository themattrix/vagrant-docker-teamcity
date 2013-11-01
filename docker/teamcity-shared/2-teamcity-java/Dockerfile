FROM mattrix/teamcity-base

# Install add-apt-repository
RUN apt-get install -qqy --force-yes software-properties-common

# Add the Oracle Java 8 installer
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update -qq

# Tell the Java installer to run silently
RUN echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections

# Install Java 8
RUN apt-get install -qqy oracle-java8-installer
