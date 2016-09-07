name := "streaming"
version := "1.0"
scalaVersion := "2.10.6"

libraryDependencies += "org.apache.spark" %% "spark-core" % "2.0.0"
libraryDependencies += "org.apache.spark" %% "spark-streaming" % "2.0.0"
libraryDependencies += "org.apache.spark" %% "spark-streaming-kafka" % "2.0.0"
libraryDependencies += "org.apache.kafka" %% "kafka" % "0.8.2.1"
