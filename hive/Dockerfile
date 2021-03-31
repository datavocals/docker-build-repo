# JAVA_HOME env has been declared in jdk image
# referrence: https://hub.docker.com/layers/openjdk/library/openjdk/8-jdk-buster/images/sha256-17ecae6f9d29f5271a0434da03e8161d5699c7e095ee9e5bb922a711437e0dca?context=explore
FROM datavocals/hadoop-2.7.7:alpha

ARG HIVE_DIST_DIR

USER root

# bigdata user group has been created in hadoop image
RUN useradd --system --no-log-init -r -g bigdata -u 1802 hive

RUN mkdir /var/run/hive /var/log/hive /usr/local/hive /etc/hive
RUN chown hive:bigdata /var/run/hive /var/log/hive /usr/local/hive /etc/hive

USER 1802:1800

COPY ${HIVE_DIST_DIR}/ /usr/local/hive/
COPY ${MYSQL_JAR_DIR}/mysql* /usr/local/hive/lib/

WORKDIR /usr/local/hive

ENV HIVE_LOG_DIR=/var/log/hive
ENV HIVE_HOME=/usr/local/hive
ENV HIVE_CONF_DIR=/etc/hive

ENV PATH="/usr/local/hive/bin:${PATH}"

# no entrypoint