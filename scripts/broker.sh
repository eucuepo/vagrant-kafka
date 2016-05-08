#!/bin/bash

#bootstrap server
$HOME/kafka_2.10-0.9.0.1/bin/kafka-server-start.sh /vagrant/config/server$1.properties &
