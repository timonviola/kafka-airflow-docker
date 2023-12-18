"""Kafka ProduceToTopicOperator example."""

from __future__ import annotations

import json
import logging
from datetime import datetime, timedelta

from airflow.providers.apache.kafka.sensors.kafka import AwaitMessageSensor
from airflow import DAG

default_args = {
    "owner": "airflow",
    "depend_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 0,
    "retry_delay": timedelta(minutes=5),
}

consumer_logger = logging.getLogger("airflow")


def await_function(message):
    consumer_logger.info(f"{message=}")
    return "hello world"
    #return str(message)
#return json.loads(message.value())


with DAG(
    "confluent-kafka-sensor",
    default_args=default_args,
    description="Example of Kafka Sensor Operator",
    schedule=None,
    start_date=datetime(2021, 1, 1),
    catchup=False,
    tags=["example", "kafka"],
) as dag:
    topic = "airflow-test"
    t2 = AwaitMessageSensor(
        kafka_config_id="kafka-airflow-test",
        task_id="react_on_message",
        topics=[topic],
        apply_function="kafka-sensor.await_function",
        xcom_push_key="kafka-sensor-test",
    )

    t2

