# -*- mode: ruby -*-
# vi: set ft=ruby :

# Config parameters
$image_version = "centos/8"
$vm_gui = false
$vm_memory_zk = ENV.fetch('VAGRANT_ZK_RAM', 2048).to_i
$vm_memory_br = ENV.fetch('VAGRANT_BR_RAM', 2048).to_i
$vm_cpus_zk = ENV.fetch('VAGRANT_ZK_CPU', 2).to_i
$vm_cpus_br = ENV.fetch('VAGRANT_BR_CPU', 2).to_i
$default_subnet = ENV.fetch('VAGRANT_SUBNET', '10.192.133.0')
$default_gw = ENV.fetch('VAGRANT_GW', '10.192.133.1')
$default_zks = ENV.fetch('VAGRANT_ZKS', 2).to_i
$default_brs = ENV.fetch('VAGRANT_BRS', 2).to_i
$subnet_ip = "#{$default_subnet.split(%r{\.\d*$}).join('')}"
#  This setting controls how much cpu time a virtual CPU can use. A value of 50 implies a single virtual CPU can use up to 50% of a single host CPU.
$default_limit_cpu = ENV.fetch('VAGRANT_CPU_LIMIT', '50')



Vagrant.configure("2") do |config|

  config.vm.box = $image_version
  config.ssh.forward_agent = true # So that boxes don't have to setup key-less ssh
  config.ssh.insert_key = false # To generate a new ssh key and don't use the default Vagrant one

  vars = { 
     "KAFKA_VERSION" => "2.5.0",
     "KAFKA_NAME" => "kafka_2.12-$KAFKA_VERSION",
     "KAFKA_TARGET" => "/vagrant/tars/",
     "KAFKA_HOME" => "$HOME/$KAFKA_NAME"
  }

  # escape environment variables to be loaded to /etc/profile.d/
  as_str = vars.map{|k,str| ["export #{k}=#{str.gsub '$', '\$'}"] }.join("\n")

  # common provisioning for all
  ## Create the list of hosts in the cluster inside a file to be loaded by hosts-file-setup script
  (1..$default_zks).each do |i|
    ip = $subnet_ip + "." + "#{i+210}"
    hostname = "vkc-zk#{i}"
    File.open("scripts/hosts.txt","a+") {|f| f.write("#{ip} #{hostname}\n") }
  end
  (1..$default_brs).each do |i|
    ip = $subnet_ip + "." + "#{i+210+$default_zks}"
    hostname = "vkc-br#{i}"
    File.open("scripts/hosts.txt","a+") {|f| f.write("#{ip} #{hostname}\n") }
  end

  config.vm.provision "shell", path: "scripts/hosts-file-setup.sh", env: vars
  config.vm.provision "shell", inline: "echo \"#{as_str}\" > /etc/profile.d/kafka_vagrant_env.sh", run: "always"
  config.vm.provision "shell", path: "scripts/init.sh", env: vars
 
  # configure zookeeper cluster
  (1..$default_zks).each do |i|
    config.vm.define "zookeeper#{i}" do |s|
      s.vm.hostname = "zookeeper#{i}"
      # network configuration
      ip = $subnet_ip + "." + "#{i+210}" # Allocating VM ip addresses starting from .210
      s.vm.network "public_network", ip: ip, netmask: "255.255.255.0", drop_nat_interface_default_route: true
      s.vm.provision "shell",
        run: "always",
        inline: "ip route add default via "+ $default_gw +" dev eth1"
      #s.vm.network "private_network", ip: "10.30.3.#{i+1}", netmask: "255.255.255.0", virtualbox__intnet: "my-network", drop_nat_interface_default_route: true
      # compute capacity
      s.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--cpuexecutioncap", $default_limit_cpu]
        vb.gui = $vm_gui
        vb.memory = $vm_memory_zk
        vb.cpus = $vm_cpus_zk
      end
      s.vm.provision "shell", run: "always", path: "scripts/zookeeper.sh", args:"#{i}", privileged: false, env: vars
    end
  end

  # configure brokers
  (1..$default_brs).each do |i|
    config.vm.define "broker#{i}" do |s|
      s.vm.hostname = "broker#{i}"
      # network configuration
      ip = $subnet_ip + "." + "#{i+210+$default_zks}" # Allocating VM ip addresses starting from .210, and last zk instance
      s.vm.network "public_network", ip: ip, netmask: "255.255.255.0", drop_nat_interface_default_route: true
      s.vm.provision "shell",
        run: "always",
        inline: "ip route add default via "+ $default_gw +" dev eth1"
      s.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--cpuexecutioncap", $default_limit_cpu]
        vb.gui = $vm_gui
        vb.memory = $vm_memory_br
        vb.cpus = $vm_cpus_br
      end
      s.vm.provision "shell", run: "always", path: "scripts/broker.sh", args:"#{i}", privileged: false, env: vars
    end
  end
end
