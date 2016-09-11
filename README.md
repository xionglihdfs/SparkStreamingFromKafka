```
docker run --rm --name=sparkstreamingfromkafka --net=host -v ${PWD}:/work -it dserban/sparkstreamingfromkafka bash
```
```
bin/kafka-console-consumer.sh --zookeeper localhost:2181 \
                              --topic analytics          \
                              --from-beginning
```
