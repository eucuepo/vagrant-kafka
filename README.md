Vagrant - Kafka
=============

Vagrant configuration to setup a partitioned Apache Kafka installation with clustered Apache Zookeeper. This project is an update from the orginal project with these changes:

* The number of Zookeeper and Broker virtual machines is now dynamic and set by the user
   * The default value is 2. There is no predefined values, or limit.
   * To change the value, set the `VAGRANT_ZKS` and `VAGRANT_BRS` value in the environment before `vagrant up` command. 
* The size of the VM is also dynamic and can be set also through environment variables
   * The dafault value is 2 vCPUs and 2048MB of RAM for both VMs
   * These are the environment variables you want to change if you want to tweak that: `VAGRANT_ZK_CPU`, `VAGRANT_ZK_RAM` for zookeeper and `VAGRANT_BR_CPU`, `VAGRANT_BR_RAM` for the broker.
* The subnet for machines is also configurable
   * The default is `10.192.133.0` and can be set through `VAGRANT_SUBNET` in the environment
   * Additional useful network parameters that are configurable are: `VAGRANT_GW`(default `10.192.133.1`) and `VAGRANT_EXTERNAL_IF` (default `eno4`).
   * The values of the network parameters are tailored to my environment. Your host is probably different. Set the default gateway and outgoing interface that matches your own host to allow the machines to connect to the Internet and to be reachable.
* The VMs guest operating system is `centos/8` 64-bit
* The kafka version is now `2.5.0`
* The user scripts in the original project are updated to make requests to a dynamic number of brokers.
* There is a CPU limit artificially added to the VMs to tell the hypervisor not to overload the host's CPU if the VM is running at full power. This is a percentage, and sets the `cpuexecutioncap` of the hypervisor through the `VAGRANT_CPU_LIMIT` variable (default `50`).
* I recommand maintainig a `kafkarc` file with all your environment variables as those are volatile in your shell. Source this file each time you log in your host, or change terminal shell so that vagrant can get those values from the environment.

Prerequisites
-------------------------

* Vagrant (tested with 2.2.9) **[make sure you are on 2.x.x version of Vagrant]**
* VirtualBox (tested with 5.1.38)

Setup
-------------------------

To start it up, just git clone this repo and execute ```vagrant up```. This will take a while the first time as it downloads all required dependencies for you.

Kafka is installed on all hosts and can be easily accessed through the environment variable ```$KAFKA_HOME```

Here is the mapping of VMs to their private IPs:

| VM Name    | Host Name | IP Address |
| ---------- | --------- | ---------- |
| zookeeper1 | vkc-zk1   | 10.192.133.211  |
| zookeeper2 | vkc-zk2   | 10.192.133.212  |
| broker1    | vkc-br1   | 10.192.133.213 |
| broker2    | vkc-br2   | 10.192.133.214 |

Hosts file entries:

```
10.192.133.211 vkc-zk1
10.192.133.212 vkc-zk2
10.192.133.213 vkc-br1
10.192.133.214 vkc-br2
```

Zookeeper servers bind to port 2181. Kafka brokers bind to port 9092. 

Let's test it!
-------------------------

First test that all nodes are up ```vagrant status```. The result should be similar to this, if you use the default values of this project :

```
Current machine states:

zookeeper1                running (virtualbox)
zookeeper2                running (virtualbox)
broker1                   running (virtualbox)
broker2                   running (virtualbox)


This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run 'vagrant status NAME''.
```

Login to any host with e.g., ```vagrant ssh broker1```. Some scripts have been included for convenience:

* Create a new topic ```/vagrant/scripts/create-topic.sh <topic name>``` (create as many as you see fit)

  **Note:** If this step fails, exit the VM and run ```vagrant up --provision``` (if error persists, please file an issue) 

* Topics can be listed with ```/vagrant/scripts/list-topics.sh```

* Start a console producer ```/vagrant/scripts/producer.sh <topic name>```. Type few messages and seperate them with new lines (`ctl-C` to exit). 

* ```/vagrant/scripts/consumer.sh <topic name>```: this will create a console consumer, getting messages from the topic created before. It will read all the messages each time starting from the beginning.

Now anything you type in producer, it will show on the consumer. 


#### Teardown


To destroy all the VMs

```bash
vagrant destroy -f
```


## Insights

### Zookeeper (ZK)

Kafka is using ZK for its coordination, bookkeeping, and configuration. 
Here are some commands you can run on any of the nodes to see some of the internal ZK structures created by Kafka. 

#### Open a ZK shell

```$KAFKA_HOME/bin/zookeeper-shell.sh 10.192.133.211:2181``` 

(you can use the IP of any of the ZK servers)


Inside the shell we can browse the zNodes similar to a Linux filesystem: 

```bash
ls /
[cluster, controller, controller_epoch, brokers, zookeeper, admin, isr_change_notification, consumers, log_dir_event_notification, latest_producer_id_block, config]

ls /brokers/topics
[t1, t2, __consumer_offsets]

ls /brokers/ids
[1, 2, 3]
```

We can see that there are two topics created (t1, t2) and we already know that we have three brokers with ids 1,2,3. 

After you have enough fun browsing ZK, type `ctl-C` to exit the shell.

#### Get ZK version

First we need to install `nc`: 

```bash
sudo yum install nc -y
```

To get the version of ZK type:

```bash
echo status | nc 10.192.133.211 2181
```

You can replace 10.192.133.211 with any ZK IP 10.192.133.<211,212> and execute the above command from any node within the cluster. 

*Q: Which Zookeeper server is the leader?*

Here is a simple script that asks each server for its mode:

```bash
for i in 211 212; do
   echo "10.192.133.$i is a "$(echo status | nc 10.192.133.$i 2181 | grep ^Mode | awk '{print $2}')
done
```

### Kafka

Let's explore other ways to ingest data to Kafa from the command line. 

Login to any of the 6 nodes

```bash
vagrant ssh zookeeper1
```

Create a topic 

```bash
 /vagrant/scripts/create-topic.sh test-one
```

Send data to the Kafka topic

```bash
echo "Yet another line from stdin" | $KAFKA_HOME/bin/kafka-console-producer.sh \
   --topic test-one --broker-list vkc-br1:9092,vkc-br2:9092
```

You can then test that the line was added by running the consumer

```bash
/vagrant/scripts/consumer.sh test-one
```

##### Add a continued stream of data

Running `vmstat` will periodically export stats about the VM you are attached to. 

```bash
>vmstat -a 1 -n 100

procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu-----
 r  b   swpd   free  inact active   si   so    bi    bo   in   cs us sy id wa st
 0  0    960 113312 207368 130500    0    0    82   197  130  176  0  1 99  0  0
 0  0    960 113312 207368 130500    0    0     0     0   60   76  0  0 100  0  0
 0  0    960 113304 207368 130540    0    0     0     0   58   81  0  0 100  0  0
 0  0    960 113304 207368 130540    0    0     0     0   53   76  0  1 99  0  0
 0  0    960 113304 207368 130540    0    0     0     0   53   78  0  0 100  0  0
 0  0    960 113304 207368 130540    0    0     0    16   64   90  0  0 100  0  0
```

Redirecing this output to Kafka creates a basic form of a streaming producer.

```bash
vmstat -a 1 -n 100 | $KAFKA_HOME/bin/kafka-console-producer.sh \
   --topic test-one --broker-list vkc-br1:9092,vkc-br2:9092,vkc-br3:9092 &
```

While the producer runs in the background you can start the consumer to see what happens

```bash
/vagrant/scripts/consumer.sh test-one
```

You should be seeing the output of `vmstat` in the consumer console. 

When you are all done, kill the consumer by `ctl-C`. The producer will terminate by itself after 100 seconds.


#### Offsets

The `create-topic.sh` script creates a topic with replication factor 3 and 1 number of partitions. 

Assuming you have completed the `vmstat` example above using topic `test-one`:

```bash
/vagrant/scripts/get-offset-info.sh test-one
test-one:0:102
```

There is one partition (id 0) and the last offset was 102 (from `vmstat`: 100 lines of reports + 2 header lines)
We asked Kafka for the last offset written so far using `--time -1` (as seen in [get-offset-info.sh](scripts/get-offset-info.sh)). You can change the time to `-2` to get the first offset. 
