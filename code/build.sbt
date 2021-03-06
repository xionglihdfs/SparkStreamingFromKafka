name := "streaming"
version := "1.0"
scalaVersion := "2.11.8"

libraryDependencies += "org.apache.spark" %% "spark-core"            % "2.0.0" % "provided"
libraryDependencies += "org.apache.spark" %% "spark-streaming"       % "2.0.0" % "provided"
libraryDependencies += "org.apache.spark" %% "spark-streaming-kafka" % "1.6.2"
libraryDependencies += "org.apache.kafka" %% "kafka"                 % "0.8.2.1"
libraryDependencies += "joda-time"        %  "joda-time"             % "2.9.4"
