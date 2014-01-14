#!/bin/bash

f [ $# -gt 0 ]; then
    /usr/local/kafka/bin/kafka-create-topic.sh --zookeeper 10.30.3.2:2181 --replica 3 --partition 1 --topic $1
else
    echo Usage: create_topic.sh <topic_name>
fi

