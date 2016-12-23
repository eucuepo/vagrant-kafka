#!/bin/bash

if [ $# -gt 0 ]; then
    $HOME/kafka_2.10-0.9.0.1/bin/kafka-topics.sh --zookeeper 10.30.3.2:2181 --replication-factor 3 --partition 1 --topic $1 --create
else
    echo "Usage: "$(basename $0)" <topic_name>"
fi

