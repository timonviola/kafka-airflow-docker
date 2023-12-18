FROM --platform=linux/amd64 apache/airflow:2.7.2-python3.11
#FROM --platform=linux/amd64 apache/airflow:2.5.0-python3.9

USER root
ARG AIRFLOW_USER_HOME=/opt/airflow

RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
    vim \
    curl \
    gnupg2 \
    unixodbc

COPY config.ini ${AIRFLOW_USER_HOME}/config.ini
COPY airflow.cfg ${AIRFLOW_USER_HOME}/airflow.cfg

# The following makes it possible that airflow discovers local modules under ./lib/
COPY ./lib ${AIRFLOW_USER_HOME}/lib
ENV PYTHONPATH=${AIRFLOW_USER_HOME}
# in a production environment, always fix the package version number
USER airflow
RUN pip install "apache-airflow==2.7.2" "apache-airflow-providers-apache-kafka==1.2.0"
RUN airflow db init
RUN airflow connections add --conn-uri kafka:///?__extra__=%7B%22bootstrap.servers%22%3A+%22127.0.0.1%3A29092%22%2C+%22group.id%22%3A+%22test%22%2C+%22auto.offset.reset%22%3A+%22earliest%22%2C+%22enable.auto.offset.store%22%3A+false%7D kafka-airflow-test


