export KAFKA_BROKER=localhost:9092
for FP in {8001..8009}
do
  echo "Starting endpoint ${FP} ..."
  export FLASK_PORT=${FP}
  nohup python webapp.py &
  sleep 0.5
done
