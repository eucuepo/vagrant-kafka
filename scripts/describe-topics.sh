#!/bin/bash

NB_ZK=$(cat /vagrant/scripts/number-zk.txt)
ZK_LIST=$(echo $(for i in $(seq $NB_ZK); do echo vkc-zk$i:2181','; done)|sed -e 's/,$//g')

$KAFKA_HOME/bin/kafka-topics.sh --describe --zookeeper $ZK_LIST
