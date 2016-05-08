vagrant-kafka
=============

Vagrant configuration to setup a partitioned Apache Kafka installation with clustered Apache Zookeeper.

This configuration will start and provision six CentOS6 VMs:

* Three hosts forming a three node Apache Zookeeper Quorum (Replicated ZooKeeper)
* Three Apache Kafka nodes with one broker each

Each host is a Centos 6.6 64-bit VM provisioned with JDK 8 and Kafka 0.9.0.1. 


Here we will be using the verion of Zookeeper that comes pre-packaged with Kafka. This will be Zookeeper version: 3.4.6 for the version of Kafka we use. 

Prerrequisites
-------------------------
* Vagrant
* VirtualBox

Setup
-------------------------

To start it up, just git clone this repo and execute ```vagrant up```. This will take a while the first time as it downloads all required dependencies for you.

Kafka is installed on all hosts at ```$HOME/kafka_2.10-0.9.0.1/```

Here is the mapping of VMs to their private IPs:

| Name        | Address    |
|-------------|------------|
|zookeeper1   | 10.30.3.2  |
|zookeeper2   | 10.30.3.3  |
|zookeeper3   | 10.30.3.4  |
|broker1      | 10.30.3.30 |
|broker2      | 10.30.3.20 |
|broker3      | 10.30.3.10 |


Let's test it!
-------------------------

First test that all nodes are up ```vagrant status```. The result should be similar to this:

```
Current machine states:

zookeeper1                running (virtualbox)
zookeeper2                running (virtualbox)
zookeeper3                running (virtualbox)
broker1                   running (virtualbox)
broker2                   running (virtualbox)
broker3                   running (virtualbox)


This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run 'vagrant status NAME''.
```

Login to any host with e.g., ```vagrant ssh broker1```. Some scripts have been included for convenience:

* Create a new topic ```/vagrant/scripts/create_topic.sh <topic name>``` (create as many as you see fit)

* Topic details can be listed with ```/vagrant/scripts/list-topics.sh```

* Start a console producer ```/vagrant/scripts/producer.sh <opic name>```. Type few messages and seperate them with new lines (Ctl-C to exit). 

* ```/vagrant/scripts/consumer.sh <topic name>```: this will create a console consumer, getting messages from the topic created before. It will read all the messages each time starting from the beginning.

Now anything you type in producer, it will show on the consumer. 


### Teardown


To destroy all the VMs

```vagrant destroy -f```


Insights
-------------

### Zookeeper (ZK)

Kafka is using ZK for its operation. Here are some commands you can run on any of the nodes to see some of the internal Zookeeper structures created by Kafka. 

#### Open a ZK shell:

```$HOME/kafka_2.10-0.9.0.1/bin/zookeeper-shell.sh 10.30.3.2:2181/```


Inspect ZK structure: 

```
ls /
[controller, controller_epoch, brokers, zookeeper, admin, isr_change_notification, consumers, config]
```

#### Get ZK version:

First we need to instal `nc` ( `sudo yum install nc -y`)

To get the version of ZK type:

```
echo status | nc 10.30.3.2 2181
```

You can replace 10.30.3.2 with any ZK IP 10.30.3.<2,3,4> and execute the above command from any node within the cluster. 


### Kafka

Here we will see some more ways we can ingest data into Kafa. 

#### Pipe data directly into Kafka

Login to any of the 6 nodes

```
vagrant ssh zookeeper1
```

Create a topic if does not exist

```
 /vagrant/scripts/create_topic.sh test-one
```

Send data to the Kafka topic

```
echo "Yet another line from stdin" | ./kafka_2.10-0.9.0.1/bin/kafka-console-producer.sh --topic test-one --broker-list 10.30.3.10:9092,10.30.3.20:9092,10.30.3.30:9092
```

You can then test that the line was added by running the consumer

```
/vagrant/scripts/consumer.sh test-one
```

#### Add a continues stream of data into Kafka

Running `vmstat` will periodically export stats about the VM you are attached to. 

```
>vmstat -a 1

procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu-----
 r  b   swpd   free  inact active   si   so    bi    bo   in   cs us sy id wa st
 0  0    960 113312 207368 130500    0    0    82   197  130  176  0  1 99  0  0
 0  0    960 113312 207368 130500    0    0     0     0   60   76  0  0 100  0  0
 0  0    960 113304 207368 130540    0    0     0     0   58   81  0  0 100  0  0
 0  0    960 113304 207368 130540    0    0     0     0   53   76  0  1 99  0  0
 0  0    960 113304 207368 130540    0    0     0     0   53   78  0  0 100  0  0
 0  0    960 113304 207368 130540    0    0     0    16   64   90  0  0 100  0  0
```

We can redirect this output into Kafka

```
vmstat -a 1 | ./kafka_2.10-0.9.0.1/bin/kafka-console-producer.sh --topic test-one --broker-list 10.30.3.10:9092,10.30.3.20:9092,10.30.3.30:9092 &
```

While the producer runs in the background you can start the consumer to see what happens

```
/vagrant/scripts/consumer.sh test-one
```

You should be seeing the output of `vmstat` in the console. 


When you are all done, kill the consumer by `ctl-C` and then type `fg` to bring the producer in foreground and `crl-C` to terminate it. 


