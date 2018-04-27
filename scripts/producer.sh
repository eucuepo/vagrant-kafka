#!/bin/bash

if [ $# -gt 0 ]; then
    $KAFKA_HOME/bin/kafka-console-producer.sh --topic "$1" --broker-list vkc-br1:9092,vkc-br2:9092,vkc-br3:9092
else
    echo "Usage: "$(basename $0)" <topic_name>"
fi
