#!/bin/bash

######################################################################
# Pre-Req (kubeadm and docker)
# =============================
# script assume that both docker and kubeadm exists 
# (if not, follow the steps below)
# 
# sudo apt-get update && apt-get install -y apt-transport-https curl
# curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
# sudo su && cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
# deb https://apt.kubernetes.io/ kubernetes-xenial main
# EOF
# sudo apt-get update
# sudo apt-get install -y kubeadm
# apt-mark hold kubeadm

# docker should also be installed to pull the images
# kubeadm config images pull
#####################################################################

NEW_REGISTRY=docker.artifact.boonlogic.io/k8s
# <k8s.gcr.io>/<image>:Vx.x.x

img_to_filename () {
  local FILENAME="${1##*/}"
  FILENAME="${FILENAME/:/_}.tar"        # escape special chars that separate name and version
  echo $FILENAME
}

img_switch_registry_tag () {
  local IMAGE_TAG="${1##*/}"
  echo "$2/$IMAGE_TAG"
}

DL_IMAGE_PATH=binaries/k8s_images
DL_PATH=$PWD/$DL_IMAGE_PATH
mkdir -p $DL_PATH

# pull down the k8s docker images
kubeadm config images pull

# export out the k8s docker images
IMAGE_LIST=$(kubeadm config images list)
for IMAGE in $IMAGE_LIST
do
  docker save -o $DL_IMAGE_PATH/$(img_to_filename $IMAGE) $IMAGE
done

# generate the loading script for k8s
echo "#!/bin/bash" > load_k8s_images.sh
echo "" >> load_k8s_images.sh
for IMAGE in $IMAGE_LIST
do
  echo "docker load -i $DL_IMAGE_PATH/$(img_to_filename $IMAGE)" >> load_k8s_images.sh
done
echo "" >> load_k8s_images.sh
for IMAGE in $IMAGE_LIST
do
  echo "docker tag $IMAGE $(img_switch_registry_tag $IMAGE $NEW_REGISTRY)" >> load_k8s_images.sh
done
echo "" >> load_k8s_images.sh
for IMAGE in $IMAGE_LIST
do
  echo "docker push $(img_switch_registry_tag $IMAGE $NEW_REGISTRY)" >> load_k8s_images.sh
done

echo "" > k8s_images_list.txt
echo "" > k8s_images_list_on_new_registry.txt
for IMAGE in $IMAGE_LIST
do
  echo "$IMAGE" >> k8s_images_list.txt
  echo "$(img_switch_registry_tag $IMAGE $NEW_REGISTRY)" >> k8s_images_list_on_new_registry.txt
done

echo ""
echo ""
echo "###############################"
cat load_k8s_images.sh

echo ""
echo ""
echo "###############################"
cat k8s_images_list_on_new_registry.txt

echo ""
echo ""
echo "###############################"
cat k8s_images_list.txt


