#!/bin/bash

echo "hosts file setup..."

sudo echo "192.168.56.2 vkc-zk1" | sudo tee -a /etc/hosts
sudo echo "192.168.56.3 vkc-zk2" | sudo tee -a /etc/hosts
sudo echo "192.168.56.4 vkc-zk3" | sudo tee -a /etc/hosts

sudo echo "192.168.56.30 vkc-br1" | sudo tee -a /etc/hosts
sudo echo "192.168.56.20 vkc-br2" | sudo tee -a /etc/hosts
sudo echo "192.168.56.10 vkc-br3" | sudo tee -a /etc/hosts