#!/bin/bash

setenforce 0
sed -i 's/SELINUX=\(enforcing\|permissive\)/SELINUX=disabled/g' /etc/selinux/config

echo  "Disabling IPv6"
echo "net.ipv6.conf.all.disable_ipv6 = 1
      net.ipv6.conf.default.disable_ipv6 = 1
      net.ipv6.conf.lo.disable_ipv6 = 1
      net.ipv6.conf.eth0.disable_ipv6 = 1" >> /etc/sysctl.conf

sysctl -p      

echo "downloading kafka...$KAFKA_VERSION"

su -c "yum -y install wget net-tools curl telnet"
#download kafka binaries if not present
if [ ! -f  $KAFKA_TARGET/$KAFKA_NAME.tgz ]; then
   mkdir -p $KAFKA_TARGET
   wget -O "$KAFKA_TARGET/$KAFKA_NAME.tgz" https://archive.apache.org/dist/kafka/"$KAFKA_VERSION/$KAFKA_NAME.tgz"
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
