from kafka import KafkaProducer
from time  import sleep

producer = KafkaProducer()

while True:
    for i in range(1,10):
        producer                            \
        .send( 'test',  str(i), key='aaa' ) \
        .get()
    sleep(20)
