#!/bin/bash

if [ $# -gt 0 ]; then
    /usr/local/kafka/bin/kafka-console-consumer.sh --from-beginning --topic $1 --zookeeper 10.30.3.2:2181 
else
    echo "Usage: consumer.sh <topic_name>"
fi

