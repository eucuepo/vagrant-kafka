#!/bin/bash

echo "downloading kafka...$KAFKA_VERSION"

#download kafka binaries if not present
if [ ! -f  $KAFKA_TARGET/$KAFKA_NAME.tgz ]; then
   mkdir -p $KAFKA_TARGET
   wget -O "$KAFKA_TARGET/$KAFKA_NAME.tgz" http://apache.claz.org/kafka/"$KAFKA_VERSION/$KAFKA_NAME.tgz"
fi

#download rpm if not present
if [ ! -f /vagrant/rpm/$JDK_RPM ]; then
    echo Downloading JDK rpm
    mkdir -p /vagrant/rpm/
    JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u$JAVA_REVISION-b12/e758a0de34e24606bca991d704f6dcbf/$JDK_RPM"
    wget -O /vagrant/rpm/$JDK_RPM --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "$JDK_URL"
fi

#disabling iptables
/etc/init.d/iptables stop

echo "installing JDK and Kafka..."

rpm -ivh /vagrant/rpm/$JDK_RPM

if [ ! -d $KAFKA_NAME ]; then 
   tar -zxvf $KAFKA_TARGET/$KAFKA_NAME.tgz
fi

chown vagrant:vagrant -R $KAFKA_NAME

echo "done installing JDK and Kafka..."

# chmod scripts
chmod u+x /vagrant/scripts/*.sh
