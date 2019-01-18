FROM ubuntu:18.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git && \
    apt-get install -y iputils-ping && \
    apt-get install -y net-tools && \
    apt-get install -y haproxy netcat net-tools



COPY balanceConfig /opt/balanceConfig
RUN chmod 755 /opt/balanceConfig

WORKDIR /etc/haproxy
RUN cat /opt/balanceConfig >> haproxy.cfg
RUN cat haproxy.cfg

RUN echo "Configurando lb"

RUN service haproxy restart

COPY entrypoint-lb.sh /opt/entrypoint-lb.sh
RUN chmod 755 /opt/entrypoint-lb.sh

ENTRYPOINT ["/opt/entrypoint-lb.sh"]

