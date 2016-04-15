JAR1=${HOME}/.ivy2/cache/com.yammer.metrics/metrics-core/jars/metrics-core-2.2.0.jar
JAR2=${HOME}/.ivy2/cache/org.apache.kafka/kafka_2.10/jars/kafka_2.10-0.8.2.1.jar
JAR3=${HOME}/.ivy2/cache/org.apache.spark/spark-streaming-kafka_2.10/jars/spark-streaming-kafka_2.10-1.6.1.jar

spark-submit                   \
--class="Streaming"            \
--jars ${JAR1},${JAR2},${JAR3} \
/opt/SparkStreamingFromKafka/code/target/scala-2.10/streaming_2.10-1.0.jar
