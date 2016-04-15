echo $(hostname) > /opt/spark/conf/slaves

${KAFKA_HOME}/bin/zookeeper-server-start.sh -daemon ${KAFKA_HOME}/config/zookeeper.properties
${KAFKA_HOME}/bin/kafka-server-start.sh -daemon ${KAFKA_HOME}/config/server.properties

${KAFKA_HOME}/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test

JAR1=${HOME}/.ivy2/cache/com.yammer.metrics/metrics-core/jars/metrics-core-2.2.0.jar
JAR2=${HOME}/.ivy2/cache/org.apache.kafka/kafka_2.10/jars/kafka_2.10-0.8.2.1.jar
JAR3=${HOME}/.ivy2/cache/org.apache.spark/spark-streaming-kafka_2.10/jars/spark-streaming-kafka_2.10-1.6.1.jar

python /opt/kafkaproducer.py &

spark-submit                     \
  --class="Streaming"            \
  --jars ${JAR1},${JAR2},${JAR3} \
  /opt/SparkStreamingFromKafka/code/target/scala-2.10/streaming_2.10-1.0.jar
