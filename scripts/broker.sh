#!/bin/bash

#bootstrap server
if [ $# -gt 0 ]; then
   $HOME/kafka_2.10-0.9.0.1/bin/kafka-server-start.sh -daemon /vagrant/config/server$1.properties
else
    echo "Usage: "$(basename $0)" <topic_name>"
fi
