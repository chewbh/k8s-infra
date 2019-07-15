#!/bin/bash

DOCKER_CONFIG=$(cat <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
)
# "storage-driver": "overlay2"
echo $DOCKER_CONFIG | jq . | sudo tee /etc/docker/daemon.json > /dev/null
cat /etc/docker/daemon.json

sudo mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
sudo systemctl daemon-reload
sudo systemctl restart docker
