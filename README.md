Trigger Airflow KafkaSensor dag

The connection is created already, the kafka topic has to be created using kafka-console.

1. `$ docker-compose up`

1. create topic (kafka container exec)
```sh
kafka-topics --create --bootstrap-server kafka:9092 --topic "airflow-test" --replication-factor 1 --partitions 1
kafka-topics --list --bootstrap-server kafka:9092
```

1. produce messages (kafka container exec)
```sh
kafka-console-producer --bootstrap-server localhost:9092 --topic airflow-test
>hello 
>world
>^Csh-4.4$ 

```
