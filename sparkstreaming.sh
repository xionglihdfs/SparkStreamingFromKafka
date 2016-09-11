JAR1=${HOME}/.ivy2/cache/com.yammer.metrics/metrics-core/jars/metrics-core-2.2.0.jar
JAR2=${HOME}/.ivy2/cache/org.apache.kafka/kafka_2.11/jars/kafka_2.11-0.8.2.1.jar
JAR3=${HOME}/.ivy2/cache/org.apache.spark/spark-streaming-kafka_2.11/jars/spark-streaming-kafka_2.11-1.6.2.jar
JAR4=${HOME}/.ivy2/cache/org.apache.kafka/kafka-clients/jars/kafka-clients-0.8.2.1.jar

echo "Executing Spark Streaming application ..."

spark-submit                             \
  --class="Streaming"                    \
  --jars ${JAR1},${JAR2},${JAR3},${JAR4} \
  /opt/SparkStreamingFromKafka/code/target/scala-2.11/streaming_2.11-1.0.jar
