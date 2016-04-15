FROM ubuntu:14.04

ADD launcher.sh /usr/bin/launcher.sh
ADD kafkaproducer.py /opt/kafkaproducer.py

RUN chmod +x /usr/bin/launcher.sh                                                               && \
    export DEBIAN_FRONTEND=noninteractive                                                       && \
    apt-get -qq update                                                                          && \
    apt-get -qq -y install wget                                                                    \
                           curl                                                                    \
                           git                                                                     \
                           vim                                                                     \
                           jq                                                                      \
                           mc                                                                      \
                           default-jdk                                                             \
                           python-pip                                                           && \
    echo 'Installing kafka-python ...'                                                          && \
    pip install kafka-python                                                                    && \
    CLOSER="https://www.apache.org/dyn/closer.cgi?as_json=1"                                    && \
    MIRROR=$(curl --stderr /dev/null ${CLOSER} | jq -r '.preferred')                            && \
    echo 'Downloading Spark ...'                                                                && \
    wget -qO /opt/spark.tgz                                                                        \
             ${MIRROR}spark/spark-1.6.1/spark-1.6.1-bin-hadoop2.6.tgz                           && \
    echo 'Extracting Spark ...'                                                                 && \
    tar -xf /opt/spark.tgz -C /opt                                                              && \
    rm /opt/spark.tgz                                                                           && \
    mv /opt/spark-* /opt/spark                                                                  && \
    echo 'Downloading Kafka ...'                                                                && \
    wget -qO /opt/kafka.tgz                                                                        \
             ${MIRROR}kafka/0.8.2.1/kafka_2.10-0.8.2.1.tgz                                      && \
    echo 'Extracting Kafka ...'                                                                 && \
    tar -xf /opt/kafka.tgz -C /opt                                                              && \
    rm /opt/kafka.tgz                                                                           && \
    mv /opt/kafka_* /opt/kafka                                                                  && \
    echo 'Downloading Zookeeper ...'                                                            && \
    wget -qO /opt/zookeeper.tgz                                                                    \
             ${MIRROR}zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz                          && \
    echo 'Extracting Zookeeper ...'                                                             && \
    tar -xf /opt/zookeeper.tgz -C /opt                                                          && \
    rm /opt/zookeeper.tgz                                                                       && \
    mv /opt/zookeeper-* /opt/zookeeper                                                          && \
    cd /opt/spark/conf                                                                          && \
    sed 's/INFO/ERROR/' log4j.properties.template > log4j.properties                            && \
    mkdir /var/lib/zookeeper                                                                    && \
    mkdir /var/lib/kafka                                                                        && \
    cd /opt/kafka/config                                                                        && \
    sed -i 's#^dataDir.*$#dataDir=/var/lib/zookeeper#' zookeeper.properties                     && \
    sed -i 's#^log.dirs.*$#log.dirs=/var/lib/kafka#' server.properties                          && \
    echo 'Installing sbt ...'                                                                   && \
    export SBTV=0.13.8                                                                          && \
    curl -sL http://dl.bintray.com/sbt/native-packages/sbt/${SBTV}/sbt-${SBTV}.tgz |               \
      gzip -d |                                                                                    \
      tar -x -C /usr/local                                                                      && \
    export PATH=/usr/local/sbt/bin:${PATH}                                                      && \
    cd /opt                                                                                     && \
    echo 'Getting code from GitHub ...'                                                         && \
    git clone https://github.com/dserban/SparkStreamingFromKafka.git                            && \
    cd /opt/SparkStreamingFromKafka/code                                                        && \
    echo 'Running sbt package ...'                                                              && \
    sbt package                                                                                 && \
    echo 'Building container, this may take a while ...'

ENV SPARK_HOME=/opt/spark                        \
    KAFKA_HOME=/opt/kafka                        \
    PYSPARK_PYTHON=/usr/bin/python               \
    PATH=/usr/local/sbt/bin:/opt/spark/bin:$PATH

CMD ["bash", "-c", "/usr/bin/launcher.sh"]

