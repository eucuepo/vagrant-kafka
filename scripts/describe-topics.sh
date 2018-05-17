#!/bin/bash

$KAFKA_HOME/bin/kafka-topics.sh --describe --zookeeper vkc-zk1:2181,vkc-zk2:2181,vkc-zk3:2181
