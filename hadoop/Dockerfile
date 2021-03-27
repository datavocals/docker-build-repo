# JAVA_HOME env has been declared in jdk image
# referrence: https://hub.docker.com/layers/openjdk/library/openjdk/8-jdk-buster/images/sha256-17ecae6f9d29f5271a0434da03e8161d5699c7e095ee9e5bb922a711437e0dca?context=explore
FROM openjdk:8-jdk-buster

ARG HADOOP_DIST_DIR

USER root

RUN groupadd --system -g 1800 -r hadoop && useradd --system --no-log-init -r -g hadoop -u 1800 hadoop

RUN mkdir /var/run/hadoop /var/log/hadoop /usr/local/hadoop /etc/hadoop
RUN chown hadoop:hadoop /var/run/hadoop /var/log/hadoop /usr/local/hadoop /etc/hadoop

USER 1800:1800

COPY ${HADOOP_DIST_DIR}/ /usr/local/hadoop/

WORKDIR /usr/local/hadoop
ENV HADOOP_PID_DIR=/var/run/hadoop
ENV HADOOP_LOG_DIR=/var/log/hadoop
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV PATH="/usr/local/hadoop/bin:/usr/local/hadoop/sbin:${PATH}"

# no entrypoint