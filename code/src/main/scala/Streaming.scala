import kafka.serializer.StringDecoder
import org.apache.spark._
import org.apache.spark.streaming._
import org.apache.spark.streaming.kafka.KafkaUtils

object Streaming {
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
                                     , Map("metadata.broker.list" -> "localhost:9092")
                                     , Set("test")
                                     )

    messages.foreachRDD {
      rdd => rdd.foreach { case (k,v) => println( ("Individual " + k, v) ) }
    }

    val sums = messages
               .map( case (k,v) => ("Aggregated " + k, v.toInt) )
               .reduceByKeyAndWindow(_ + _, _ - _, Seconds(30), Seconds(5) )

    sums.print()

    ssc.start()
    ssc.awaitTermination()

    println("Spark Streaming from a Kafka topic")
  }
}

