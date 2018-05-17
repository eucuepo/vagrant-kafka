#!/bin/bash

if [ $# -gt 0 ]; then
    $KAFKA_HOME/bin/kafka-topics.sh --zookeeper vkc-zk1:2181 --replication-factor 3 --partitions 1 --topic $1 --create
else
    echo "Usage: "$(basename $0)" <topic_name>"
fi

