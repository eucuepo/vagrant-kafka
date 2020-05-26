#!/bin/bash

echo "hosts file setup..."

cat /vagrant/scripts/hosts.txt |sudo tee -a /etc/hosts
mv /vagrant/scripts/hosts.txt  /vagrant/scripts/hosts.txt.done
