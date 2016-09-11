echo $(hostname) > /opt/spark/conf/slaves

echo "Starting Kafka and waiting for it to become fully operational ..."

${KAFKA_HOME}/bin/zookeeper-server-start.sh -daemon ${KAFKA_HOME}/config/zookeeper.properties
${KAFKA_HOME}/bin/kafka-server-start.sh -daemon ${KAFKA_HOME}/config/server.properties

sleep 10

echo "Creating topics ..."

${KAFKA_HOME}/bin/kafka-topics.sh --create                   \
                                  --zookeeper localhost:2181 \
                                  --replication-factor 1     \
                                  --partitions 6             \
                                  --topic raw                \
                                  2>/dev/null
${KAFKA_HOME}/bin/kafka-topics.sh --create                   \
                                  --zookeeper localhost:2181 \
                                  --replication-factor 1     \
                                  --partitions 6             \
                                  --topic analytics          \
                                  2>/dev/null

# /usr/bin/kafkaproducer.py &

# echo "Waiting until enough messages have accumulated ..."

# sleep 20

/usr/bin/sparkstreaming.sh
