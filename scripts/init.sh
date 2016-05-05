#!/bin/bash
#download rpm if not present

KAFKA_VERSION="0.9.0.1"
KAFKA_NAME="kafka_2.10-$KAFKA_VERSION"
KAFKA_TARGET="/vagrant/tars/"

echo Downloading kafka...$KAFKA_VERSION 

if [ ! -f  $KAFKA_TARGET/$KAFKA_NAME.tgz ]; then
   mkdir -p $KAFKA_TARGET
   wget -O "$KAFKA_TARGET/$KAFKA_NAME.tgz" http://apache.claz.org/kafka/"$KAFKA_VERSION/$KAFKA_NAME.tgz"
fi

JDK_VERSION="jdk-8u73-linux-x64"
JDK_RPM="$JDK_VERSION.rpm"

if [ ! -f /vagrant/rpm/$JDK_RPM ]; then
    echo Downloading JDK rpm
    mkdir -p /vagrant/rpm/
    wget -O /vagrant/rpm/$JDK_RPM --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u73-b02/$JDK_RPM"
fi

#disabling iptables
/etc/init.d/iptables stop

echo "installing jdk and kafka ..."

rpm -ivh /vagrant/rpm/$JDK_RPM

if [ ! -d $KAFKA_NAME ]; then 
   tar -zxvf $KAFKA_TARGET/$KAFKA_NAME.tgz
fi

chown vagrant:vagrant -R $KAFKA_NAME

echo "done installing jdk and Kafka"

# chmod scripts
chmod u+x /vagrant/scripts/*.sh
