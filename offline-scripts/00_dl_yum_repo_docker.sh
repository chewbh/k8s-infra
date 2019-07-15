#!/bin/bash

############################################
# Download Docker CE YUM repository 
############################################
# Kubernetes > v1.14 prefer docker v18.06
############################################

BASE_PATH=$PWD/binaries
REPOS_NAME=docker-ce

DOCKER_BASE_URL=download.docker.com
OS_VARIANT=linux/centos
OS_VERSION=$OS_VARIANT/7
BASE_ARCH=x86_64
CHANNEL=stable
PKGS=Packages
DL_URL=https://$DOCKER_BASE_URL/$OS_VERSION/$BASE_ARCH/$CHANNEL/$PKGS/

mkdir -p $BASE_PATH
wget -r -nH -np -R "index.html*" -P $BASE_PATH/tmp $DL_URL

# downloaded package path => tmp/linux/centos/7/x86_64/stable/Packages/
mv $BASE_PATH/tmp/$OS_VARIANT $BASE_PATH/$REPOS_NAME
rm -rf $BASE_PATH/tmp

wget -P $BASE_PATH/$REPOS_NAME https://download.docker.com/linux/centos/gpg


