#!/bin/bash

f [ $# -gt 0 ]; then
    /usr/local/kafka/bin/kafka-console-producer.sh --broker-list 10.30.3.10:9092,10.30.3.20,10.30.3.30 --topic $1
else
    echo Usage: producer.sh <topic_name>
fi

