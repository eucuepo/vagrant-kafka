#!/bin/bash

if [ $# -gt 0 ]; then
    $KAFKA_HOME/bin/kafka-topics.sh --zookeeper 10.30.3.2:2181 --replication-factor 3 --partitions 1 --topic $1 --create
else
    echo "Usage: "$(basename $0)" <topic_name>"
fi

