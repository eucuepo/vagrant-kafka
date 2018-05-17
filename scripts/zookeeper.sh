#!/bin/bash

# create myid file. see http://zookeeper.apache.org/doc/r3.1.1/zookeeperAdmin.html#sc_zkMulitServerSetup
if [ ! -d /tmp/zookeeper ]; then
    echo creating zookeeper data dir...
    mkdir /tmp/zookeeper
    echo $1 > /tmp/zookeeper/myid
fi

echo starting zookeeper...
nohup $KAFKA_HOME/bin/zookeeper-server-start.sh /vagrant/config/zookeeper.properties 0<&- &> /tmp/zookeeper.log &
sleep 2
