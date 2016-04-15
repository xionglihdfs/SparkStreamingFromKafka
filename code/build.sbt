name := "streaming"
version := "1.0"
scalaVersion := "2.10.6"

libraryDependencies += "org.apache.spark" %% "spark-core" % "1.6.1"
libraryDependencies += "org.apache.spark" %% "spark-streaming" % "1.6.1"
libraryDependencies += "org.apache.spark" %% "spark-streaming-kafka" % "1.6.1"
libraryDependencies += "org.apache.kafka" %% "kafka" % "0.8.2.1"
