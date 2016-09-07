export DEBIAN_FRONTEND=noninteractive
localedef -i en_US -f UTF-8 en_US.UTF-8
apt-get -qq update
apt-get -qq install --no-install-recommends -y \
  wget curl git vim jq mc ca-certificates \
  librdkafka-dev libev-dev libsnappy-dev zlib1g-dev
echo 'Downloading Anaconda ...'
wget -qO /opt/Anaconda.sh \
         https://repo.continuum.io/archive/Anaconda2-4.1.1-Linux-x86_64.sh
echo 'Installing Anaconda ...'
cd /opt
bash Anaconda.sh -b -p /opt/anaconda
rm Anaconda.sh
mv /opt/anaconda/bin/sqlite3 /opt/anaconda/bin/sqlite3.orig
echo 'Installing pykafka ...'
PATH=/opt/anaconda/bin:$PATH pip install pykafka kafka-python
echo 'Downloading JDK ...'
wget --no-check-certificate --no-cookies                         \
     --header "Cookie: oraclelicense=accept-securebackup-cookie" \
     -qO /opt/jdk.tgz                                            \
         http://download.oracle.com/otn-pub/java/jdk/8u102-b14/jdk-8u102-linux-x64.tar.gz
echo 'Extracting JDK ...'
tar -xf /opt/jdk.tgz -C /opt
rm /opt/jdk.tgz
mv /opt/jdk* /opt/jdk
CLOSER="https://www.apache.org/dyn/closer.cgi?as_json=1"
MIRROR=$(curl --stderr /dev/null ${CLOSER} | jq -r '.preferred')
echo 'Downloading Spark ...'
wget -qO /opt/spark.tgz \
         ${MIRROR}spark/spark-2.0.0/spark-2.0.0-bin-hadoop2.7.tgz
echo 'Extracting Spark ...'
tar -xf /opt/spark.tgz -C /opt
rm /opt/spark.tgz
mv /opt/spark-* /opt/spark
cd /opt/spark/conf
sed 's/INFO/ERROR/;s/WARN/ERROR/' log4j.properties.template > log4j.properties
echo 'Downloading Kafka ...'
wget -qO /opt/kafka.tgz \
         ${MIRROR}kafka/0.8.2.1/kafka_2.10-0.8.2.1.tgz
echo 'Extracting Kafka ...'
tar -xf /opt/kafka.tgz -C /opt
rm /opt/kafka.tgz
mv /opt/kafka_* /opt/kafka
echo 'Downloading Zookeeper ...'
wget -qO /opt/zookeeper.tgz \
         ${MIRROR}zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz
echo 'Extracting Zookeeper ...'
tar -xf /opt/zookeeper.tgz -C /opt
rm /opt/zookeeper.tgz
mv /opt/zookeeper-* /opt/zookeeper
mkdir /var/lib/zookeeper
mkdir /var/lib/kafka
cd /opt/kafka/config
sed -i 's#^dataDir.*$#dataDir=/var/lib/zookeeper#' zookeeper.properties
sed -i 's#^log.dirs.*$#log.dirs=/var/lib/kafka#' server.properties
echo 'Installing sbt ...'
export SBTV=0.13.12
curl -sL http://dl.bintray.com/sbt/native-packages/sbt/${SBTV}/sbt-${SBTV}.tgz | \
  gzip -d |                                                                      \
  tar -x -C /usr/local
cd /opt
echo 'Getting code from GitHub ...'
git clone https://github.com/dserban/SparkStreamingFromKafka.git
cd /opt/SparkStreamingFromKafka
cp launcher.sh /usr/bin/
chmod +x /usr/bin/launcher.sh 
cp kafkaproducer.py /usr/bin/
chmod +x /usr/bin/kafkaproducer.py 
cd /opt/SparkStreamingFromKafka/code
echo 'Running sbt package ...'
PATH=/usr/local/sbt/bin:$PATH sbt package
echo 'Building container, this may take a while ...'

