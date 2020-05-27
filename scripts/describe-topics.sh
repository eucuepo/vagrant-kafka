#!/bin/bash

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
NB_ZK=$(cat $parent_path/number-zk.txt)
ZK_LIST=$(echo $(for i in $(seq $NB_ZK); do echo vkc-zk$i:2181','; done)|sed -e 's/,$//g')

$KAFKA_HOME/bin/kafka-topics.sh --describe --zookeeper $ZK_LIST
