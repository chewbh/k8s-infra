#!/bin/bash

BASE_PATH=$PWD/binaries
mkdir -p $BASE_PATH

REPOS_NAME=kubernetes
PKGS_SUBPATH=kubernetes-el7-x86_64

DL_BASEURL=packages.cloud.google.com
DL_BASE_PATH=yum
DL_URL=https://$DL_BASEURL/$DL_BASE_PATH/repos/$PKGS_SUBPATH/

# move existing files to download directory structure (use for skipping files that already downloaded)
if [ -d "$BASE_PATH/$REPOS_NAME/repos" ]; then
  mkdir -p $BASE_PATH/tmp/$DL_BASE_PATH/repos
  mv $BASE_PATH/$REPOS_NAME/repos/* $BASE_PATH/tmp/$DL_BASE_PATH/repos
fi

# download the official kubernetes yum repo
wget -r -nH -np -N -R "index.html*" -e robots=off -P $BASE_PATH/tmp $DL_URL

# remove any duplicate accidentially created
find $BASE_PATH/tmp/$DL_BASE_PATH -name \*.1 -type f -delete

# move the downloaded files (repodata) according to wanted directory structure
mkdir -p $BASE_PATH/$REPOS_NAME/repos
mv $BASE_PATH/tmp/$DL_BASE_PATH/repos/* $BASE_PATH/$REPOS_NAME/repos
rm -rf $BASE_PATH/tmp

# download the gpg keys
wget -N -P $BASE_PATH/$REPOS_NAME https://packages.cloud.google.com/yum/doc/yum-key.gpg
wget -N -P $BASE_PATH/$REPOS_NAME https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg

# download the actual kubernete binaries based on info from the downloaded repodata
mkdir -p $BASE_PATH/$REPOS_NAME/pool
grep -Po 'href="\.\./\.\./\K.*?(?=")' $BASE_PATH/$REPOS_NAME/repos/$PKGS_SUBPATH/repodata/primary.xml | while read -r filename ; do
  echo "downloading https://$DL_BASEURL/$DL_BASE_PATH/$filename"
  wget -nc -P $BASE_PATH/$REPOS_NAME/pool https://$DL_BASEURL/$DL_BASE_PATH/$filename
done

#cat <<EOF > /etc/yum.repos.d/kubernetes.repo
#[kubernetes]
#name=Kubernetes
#baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
#enabled=1
#gpgcheck=1
#repo_gpgcheck=1
#gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
#exclude=kube*
#EOF

#setenforce 0
#yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
#systemctl enable kubelet && systemctl start kubelet


