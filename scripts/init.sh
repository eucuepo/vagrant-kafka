#!/bin/bash
#download rpm if not present
if [ ! -f /vagrant/rpm/kafka-0.8.0-9.x86_64.rpm ]; then
    echo Downloading kafka...
    wget http://poole.im/files/kafka-0.8.0-9.x86_64.rpm -P /vagrant/rpm/
fi

if [ ! -f /vagrant/rpm/jdk-7u45-linux-x64.rpm ]; then
    echo Downloading JDK rpm
    wget -O /vagrant/rpm/jdk-7u45-linux-x64.rpm --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com" "http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-linux-x64.rpm" 
fi

#disabling iptables
/etc/init.d/iptables stop
echo installing jdk and kafka...
rpm -ivh /vagrant/rpm/jdk-7u45-linux-x64.rpm
rpm -ivh /vagrant/rpm/kafka-0.8.0-9.x86_64.rpm
echo done installing jdk and kafka
# chmod scripts
chmod u+x /vagrant/scripts/*.sh
