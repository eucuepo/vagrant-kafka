#!/bin/bash

echo "downloading kafka...$KAFKA_VERSION"

su -c "yum -y install wget"
#download kafka binaries if not present
if [ ! -f  $KAFKA_TARGET/$KAFKA_NAME.tgz ]; then
   mkdir -p $KAFKA_TARGET
   wget -O "$KAFKA_TARGET/$KAFKA_NAME.tgz" http://apache.mirrors.hoobly.com/kafka/"$KAFKA_VERSION/$KAFKA_NAME.tgz"
   # http://apache.mirrors.hoobly.com/kafka/2.8.0/kafka_2.13-2.8.0.tgz
fi

echo "installing JDK and Kafka..."

su -c "yum -y install java-1.8.0-openjdk-devel"

#disabling iptables
/etc/init.d/iptables stop

if [ ! -d $KAFKA_NAME ]; then 
   tar -zxvf $KAFKA_TARGET/$KAFKA_NAME.tgz
fi

chown vagrant:vagrant -R $KAFKA_NAME

echo "done installing JDK and Kafka..."

# chmod scripts
chmod u+x /vagrant/scripts/*.sh