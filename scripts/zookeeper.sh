#!/bin/bash

# create myid file. see http://zookeeper.apache.org/doc/r3.1.1/zookeeperAdmin.html#sc_zkMulitServerSetup
mkdir /tmp/zookeeper
echo $1 > /tmp/zookeeper/myid
# echo starting zookeeper 
/usr/local/kafka-0.8.0/bin/zookeeper-server-start.sh /vagrant/config/zookeeper.properties > /tmp/zookeeper.log &
