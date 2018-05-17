#!/bin/bash

if [ $# -gt 0 ]; then
   $KAFKA_HOME/bin/kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list vkc-br1:9092,vkc-br2:9092,vkc-br3:9092 --topic $1 --time -1
else
    echo "Usage: "$(basename $0)" <topic_name>"
fi
