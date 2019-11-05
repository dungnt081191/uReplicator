FROM openjdk:8-jre

RUN apt update && apt install -y procps pcregrep
COPY confd-0.15.0-linux-amd64 /usr/local/bin/confd
COPY uReplicator-Distribution/target/uReplicator-Distribution-pkg /uReplicator
COPY config uReplicator/config
COPY confd /etc/confd
COPY prestop-worker.sh /prestop-worker.sh
COPY prestop-controller.sh /prestop-controller.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /*.sh && \
    chmod +x /usr/local/bin/confd && \
    chmod +x /uReplicator/bin/*.sh

ENTRYPOINT [ "/entrypoint.sh" ]
