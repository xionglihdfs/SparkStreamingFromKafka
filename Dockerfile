FROM ubuntu:14.04

COPY install.sh /usr/bin/install.sh

RUN chmod +x /usr/bin/install.sh && \
    bash install.sh              && \
    echo 'Building container, this may take a while ...'

ENV SPARK_HOME=/opt/spark                   \
    KAFKA_HOME=/opt/kafka                   \
    PYSPARK_PYTHON=/opt/anaconda/bin/python \
    PATH=/opt/anaconda/bin:/usr/local/sbt/bin:/opt/spark/bin:$PATH

CMD ["/usr/bin/launcher.sh"]
