FROM cluster-base

# -- Layer: zeppelin

ARG zeppelin_version=0.9.0
ARG zeppelin_port=8889


RUN apt-get update -y && \
    apt-get install -y wget && \
    wget https://downloads.apache.org/zeppelin/zeppelin-${zeppelin_version}/zeppelin-${zeppelin_version}-bin-all.tgz -O /tmp/zeppelin.tgz && \
    tar -xzvf /tmp/zeppelin.tgz -C /opt/ && \
    mv /opt/zeppelin-* /opt/zeppelin && \
    rm /tmp/zeppelin.tgz

RUN echo '{ "allow_root": true }' > /root/.bowerrc

ENV ZEPPELIN_ADDR "0.0.0.0"
ENV ZEPPELIN_PORT ${zeppelin_port}
ENV ZEPPELIN_NOTEBOOK_DIR ${SHARED_WORKSPACE}"/zeppelin/notebooks"
ENV ZEPPELIN_LOG_DIR ${SHARED_WORKSPACE}"/zeppelin/log"

EXPOSE ${zeppelin_port}
# my WorkDir
RUN mkdir -p /opt/zeppelin/work && \
    mkdir -p ZEPPELIN_NOTEBOOK_DIR && \
    mkdir -p ZEPPELIN_LOG_DIR && \
    mkdir -p /opt/zeppelin/run

WORKDIR /opt/zeppelin/bin

CMD ["/opt/zeppelin/bin/zeppelin.sh"]

