#!/bin/bash

NB_BROKERS=$(cat /vagrant/scripts/number-br.txt)
BROKER_LIST=$(echo $(for i in $(seq $NB_BROKERS); do echo vkc-br$i:9092','; done)|sed -e 's/,$//g')
if [ $# -gt 0 ]; then
    $KAFKA_HOME/bin/kafka-console-producer.sh --topic "$1" --broker-list $BROKER_LIST
else
    echo "Usage: "$(basename $0)" <topic_name>"
fi
