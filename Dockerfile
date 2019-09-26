FROM oracle/graalvm-ce:latest AS builder

ARG hazelcast_version=3.12.1

RUN gu install native-image
RUN yum -y install wget

WORKDIR /cp

RUN wget -q -c https://repo1.maven.org/maven2/com/hazelcast/hazelcast-all/${hazelcast_version}/hazelcast-all-${hazelcast_version}.jar

ADD generate-config.sh /

RUN chmod +x /generate-config.sh

RUN /generate-config.sh hazelcast-all-${hazelcast_version}.jar

RUN native-image -H:ConfigurationFileDirectories=$PWD/merged-config-dir -jar hazelcast-all-${hazelcast_version}.jar

RUN mv hazelcast-all-${hazelcast_version} hazelcast