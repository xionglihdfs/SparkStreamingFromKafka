import java.util.Properties
import kafka.serializer.StringDecoder
import org.apache.spark._
import org.apache.spark.streaming._
import org.apache.spark.streaming.kafka.KafkaUtils
import org.apache.kafka.clients.producer.{KafkaProducer,ProducerRecord}

object Streaming {
  val RAW_DATA_TOPIC            = "raw"
  val STREAMING_ANALYTICS_TOPIC = "analytics"

  val KAFKA_BROKER = "localhost:9092"
  val SERIALIZER   = "org.apache.kafka.common.serialization.StringSerializer"

  val kafka_producer_props = new Properties()
  kafka_producer_props.put("bootstrap.servers", KAFKA_BROKER)
  kafka_producer_props.put("key.serializer"   , SERIALIZER)
  kafka_producer_props.put("value.serializer" , SERIALIZER)
  kafka_producer_props.put("producer.type"    , "sync")

  def main(args: Array[String]) {
    val conf = new SparkConf().setMaster("local[*]").setAppName("streaming")
    val sc = new SparkContext(conf)
    val ssc = new StreamingContext(sc, Seconds(1))
    ssc.checkpoint("/tmp/sparkstreamingcheckpoint")

    val messages =
      KafkaUtils.createDirectStream[ String
                                   , String
                                   , StringDecoder
                                   , StringDecoder
                                   ] ( ssc
                                     , Map("metadata.broker.list" -> KAFKA_BROKER)
                                     , Set(RAW_DATA_TOPIC)
                                     )

//  messages.foreachRDD {
//    rdd => rdd.foreach { case (k,v) => println( ("Individual " + k, v) ) } }

    val preprocessed = messages
                       .map { case (k,v) => (k,v.toInt) }

    val analytics = preprocessed
                    .reduceByKeyAndWindow(_ + _, _ - _, Seconds(30), Seconds(5) )
                    .filter { case (k,v) => v != 0 }

    val grouped_by_first_letter = preprocessed
                                  .map { case (k,v) => (s"begin_with_${k(0)}",v) }
                                  .reduceByKeyAndWindow(_ + _, _ - _, Seconds(30), Seconds(5) )
                                  .filter { case (k,v) => v != 0 }

    val grouped_by_length = preprocessed
                            .map { case (k,v) => (s"have_length_${k.length}",v) }
                            .reduceByKeyAndWindow(_ + _, _ - _, Seconds(30), Seconds(5) )
                            .filter { case (k,v) => v != 0 }

    analytics.foreachRDD {
      rdd => rdd.foreachPartition {
        partitionOfRecords => {
          val kafka_producer = new KafkaProducer[String,String](kafka_producer_props)
          partitionOfRecords.foreach {
            case (k,v) => {
              val analytics_record = new ProducerRecord(STREAMING_ANALYTICS_TOPIC, k, (k,v).toString)
              kafka_producer.send(analytics_record).get } } } } }

    grouped_by_first_letter.foreachRDD {
      rdd => rdd.foreachPartition {
        partitionOfRecords => {
          val kafka_producer = new KafkaProducer[String,String](kafka_producer_props)
          partitionOfRecords.foreach {
            case (k,v) => {
              val analytics_record = new ProducerRecord(STREAMING_ANALYTICS_TOPIC, k, (k,v).toString)
              kafka_producer.send(analytics_record).get } } } } }

    grouped_by_length.foreachRDD {
      rdd => rdd.foreachPartition {
        partitionOfRecords => {
          val kafka_producer = new KafkaProducer[String,String](kafka_producer_props)
          partitionOfRecords.foreach {
            case (k,v) => {
              val analytics_record = new ProducerRecord(STREAMING_ANALYTICS_TOPIC, k, (k,v).toString)
              kafka_producer.send(analytics_record).get } } } } }

    analytics.print()

    ssc.start()
    ssc.awaitTermination()

    println("Spark Streaming from a Kafka topic")
  }
}
