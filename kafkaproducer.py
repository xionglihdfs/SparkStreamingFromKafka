from kafka import KafkaProducer

producer = KafkaProducer()

for i in range(1,10):
    producer                            \
    .send( 'test',  str(i), key='aaa' ) \
    .get()

