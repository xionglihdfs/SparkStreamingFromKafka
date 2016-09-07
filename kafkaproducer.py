#!/usr/bin/env python

from time                 import sleep
from pykafka              import KafkaClient as KC
from pykafka.partitioners import hashing_partitioner

kafka_client = KC(hosts='localhost:9092')

test_topic = kafka_client.topics['test']

producer = test_topic.get_sync_producer(partitioner=hashing_partitioner)

while True:
    sleep(20)
    for i in range(1,10):
        producer.produce( str(i), partition_key='aaa' )
