#!/bin/bash

#bootstrap server
/usr/local/kafka-0.8.0/bin/kafka-server-start.sh /vagrant/config/server$1.properties &
