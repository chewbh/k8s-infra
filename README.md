## Kubernetes HA Cluster Setup

Vagrant and Ansible playbooks for building a plain old on-premise kubernetes cluster.
For a full list of supported features check below.

- Includes building the infrastructure and taking care of the prerequisite
- Build the nodes, prepare them (OS settings, etc) and then install kubernetes
- Create the cluster

It supports offline setup.

Local Dev Environment
-----------------------

Both Vagrant and Ansible are used to automate the entire Vm setup in VirtualBox environment.


1. Install Vagrant locally. Follows instruction on https://www.vagrantup.com/intro/getting-started/install.html

   In addition, install the following Vagrant's plugins:

```sh
vagrant plugin install vagrant-share
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-hostmanager
```

3. Follow the steps below on shell / command line:

```sh
# clone this git repository
git clone git@github.com:chewbh/k8s-infra.git

# navigate to the root directory of the cloned repo
cd k8s-infra

# build the entire VM for the cluster
# vagrant will call ansible right after VM provisioning to create cluster
# you might need to wait for awhile (e.g. 20-60 mins) depending on macine specs and internet speed
vagrant up

# to remove VM (when no longer needed after use)
vagrant destroy

```

Cloud or On Premise Environment
-------------------------------

1. Install Ansible locally (for Linux OS only).

2. Follow the steps below on shell / command line:

```sh
# clone this git repository
git clone git@github.com:chewbh/k8s-infra.git

# navigate to the root directory of the cloned repo
cd k8s-infra/provisioning

# run the ansible playbooks
ansible-playbook -i production create_k8s_cluster.yaml
```

Requirements
-------------

- Ansible 2.6+

- Expects CentOS/RHEL hosts


Discovered Issues
-------------------
- <to be added>

