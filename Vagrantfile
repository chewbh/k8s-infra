# -*- mode: ruby -*-
# vi: set ft=ruby :

# defined environment configuration
VM_IMAGE_NAME = "centos/7"
VM_IMAGE_VERSION = "v1803.01"  # Centos V7.4
K8S_CTRL_PLANE_NODES = 3
K8S_WORKER_NODES = 2

# support older styles for backwards compatibility
Vagrant.configure("2") do |config|

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = VM_IMAGE_NAME
  config.vm.box_version = VM_IMAGE_VERSION

  # Disable automatic box update checking. boxes will only be checked for
  # updates when the user runs `vagrant box outdated`.
  config.vm.box_check_update = false

  # set auto_update to true to check the correct
  # "addition version" when booting the machine
  config.vbguest.auto_update = true
  config.vbguest.auto_reboot = true

  # made all VMs' host name resolvable among each other
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  # copy public SSH keys to the VM to enable passwordless login for vagrant user
  config.vm.provision "file", source: "ssh_key/id_rsa", destination: "/home/vagrant/.ssh/id_rsa"
  public_key = File.read("ssh_key/id_rsa.pub")
  config.vm.provision "shell", :inline =>"
    echo 'Copying public SSH keys to the VM'
    mkdir -p /home/vagrant/.ssh
    chmod 700 /home/vagrant/.ssh
    echo '#{public_key}' >> /home/vagrant/.ssh/authorized_keys
    chmod -R 600 /home/vagrant/.ssh/authorized_keys
    echo 'Host n-group3-* 192.168.*.*' >> /home/vagrant/.ssh/config
    echo 'StrictHostKeyChecking no' >> /home/vagrant/.ssh/config
    echo 'UserKnownHostsFile /dev/null' >> /home/vagrant/.ssh/config
    chmod -R 600 /home/vagrant/.ssh/config
  ", privileged: false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM.
  # The first argument is the path on the host
  # config.vm.synced_folder "../data", "/vagrant_data"

  # kubernetes HA setup that uses stacked etcd topology
  # hence 3 control plane (or k8s master) nodes

  (1..K8S_CTRL_PLANE_NODES).each do |i|
    config.vm.define "dev-k8sm0#{i}" do |master|
      master.vm.hostname = "dev-k8sm0#{i}"
      master.vm.network "private_network", ip: "192.168.66.#{1+i}"

      master.vm.provider "virtualbox" do |vb|
        # Customize the amount of memory and vcpu on the VM (for virtualbox):
        vb.customize ["modifyvm", :id, "--cpus", "2", "--memory", "4096"]
      end
      master.vm.provider "vmware_desktop" do |v|
        # Customize the amount of memory and vcpu on the VM (for vmware desktop):
        v.vmx["numvcpus"] = "2"
        v.vmx["memsize"] = "4096"
      end
    end
  end

  (1..K8S_WORKER_NODES).each do |i|
    config.vm.define "dev-k8sw0#{i}" do |node|
      node.vm.hostname = "dev-k8sw0#{i}"
      node.vm.network "private_network", ip: "192.168.66.#{K8S_CTRL_PLANE_NODES+1+i}"

      node.vm.provider "virtualbox" do |vb|
        # Customize the amount of memory and vcpu on the VM:
        vb.customize ["modifyvm", :id, "--cpus", "2", "--memory", "4096"]
      end
      node.vm.provider "vmware_desktop" do |v|
        # Customize the amount of memory and vcpu on the VM:
        v.vmx["numvcpus"] = "2"
        v.vmx["memsize"] = "4096"
      end

      # Only execute once the Ansible provisioner,
      # when all the machines are up and ready.
      if i == K8S_WORKER_NODES
        # node.vm.synced_folder "provisioning/", "/ansible/provisioning", create: true
        node.vm.provision "ansible_local" do |ansible|
          ansible.verbose = "v"
          ansible.limit = "all"
          ansible.playbook = "/vagrant/provisioning/create_hadoop_cluster.yaml"
          ansible.groups = {
            "k8s-masters" => ["dev-k8sm0[1:#{K8S_CTRL_PLANE_NODES}]"],
            "k8s-nodes" => ["dev-k8sw0[1:#{K8S_WORKER_NODES}]"],
            "development:children" => [
              "k8s-masters",
              "k8s-nodes"
            ]
          }
        end
      end
    end
  end

end
