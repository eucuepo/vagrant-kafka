#!/bin/bash

REPLICA_FACTOR=$(cat /vagrant/scripts/number-br.txt)
if [ $# -gt 0 ]; then
    $KAFKA_HOME/bin/kafka-topics.sh --zookeeper vkc-zk1:2181 --replication-factor $REPLICA_FACTOR --partitions 1 --topic $1 --create
else
    echo "Usage: "$(basename $0)" <topic_name>"
fi

