export KAFKA_BROKER=localhost:9092
for FP in {8001..8009}
do
  export FLASK_PORT=${FP}
  nohup python webapp.py &
done
