#!/bin/bash

#bootstrap server
if [ $# -gt 0 ]; then
   $KAFKA_HOME/bin/kafka-server-start.sh -daemon /vagrant/config/server$1.properties
else
    echo "Usage: "$(basename $0)" <broker_id>"
fi
