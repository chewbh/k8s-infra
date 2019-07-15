#!/bin/bash

K8S_STABLE_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
echo "Latest Kubernetes stable version: $K8S_STABLE_VERSION"

docker_img_from_yaml() {
  local IMAGE_LINE=$(curl -s $1 | grep $2)
  local IMAGE_TAG="${IMAGE_LINE##* }"
  IMAGE_TAG=$(echo $IMAGE_TAG | xargs)
  echo $IMAGE_LINE
  echo $IMAGE_TAG
}

img_to_filename () {
  local FILENAME="${1##*/}"
  FILENAME="${FILENAME/:/_}.tar"        # escape special chars that separate name and version
  echo $FILENAME
}

img_switch_registry_tag () {
  local IMAGE_TAG="${1##*/}"
  echo "$2/$IMAGE_TAG"
}

echo "##############################"
#echo $DASHBOARD_IMAGE
#echo $IMAGE

K8S_DASHBOARD_FILE="https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml"

# K8S_VER_ID=$(kubectl version | base64 | tr -d '\n')
K8S_VER_ID="Q2xpZW50IFZlcnNpb246IHZlcnNpb24uSW5mb3tNYWpvcjoiMSIsIE1pbm9yOiIxNSIsIEdpdFZlcnNpb246InYxLjE1LjAiLCBHaXRDb21taXQ6ImU4NDYyYjViNWRjMjU4NGZkY2QxOGU2YmNmZTlmMWU0ZDk3MGE1MjkiLCBHaXRUcmVlU3RhdGU6ImNsZWFuIiwgQnVpbGREYXRlOiIyMDE5LTA2LTE5VDE2OjQwOjE2WiIsIEdvVmVyc2lvbjoiZ28xLjEyLjUiLCBDb21waWxlcjoiZ2MiLCBQbGF0Zm9ybToibGludXgvYW1kNjQifQpTZXJ2ZXIgVmVyc2lvbjogdmVyc2lvbi5JbmZve01ham9yOiIxIiwgTWlub3I6IjE1IiwgR2l0VmVyc2lvbjoidjEuMTUuMCIsIEdpdENvbW1pdDoiZTg0NjJiNWI1ZGMyNTg0ZmRjZDE4ZTZiY2ZlOWYxZTRkOTcwYTUyOSIsIEdpdFRyZWVTdGF0ZToiY2xlYW4iLCBCdWlsZERhdGU6IjIwMTktMDYtMTlUMTY6MzI6MTRaIiwgR29WZXJzaW9uOiJnbzEuMTIuNSIsIENvbXBpbGVyOiJnYyIsIFBsYXRmb3JtOiJsaW51eC9hbWQ2NCJ9Cg=="

## Before installing Weave Net, you should make sure the following ports are not blocked by your firewall:
## TCP 6783 and UDP 6783/6784. For more details, see the FAQ.
WEAVE_NET_FILE="https://cloud.weave.works/k8s/net?k8s-version=$K8S_VER_ID"

DOCKER_IMAGE=$(docker_img_from_yaml $K8S_DASHBOARD_FILE 'kubernetes-dashboard-amd64')
echo $DOCKER_IMAGE
echo $(img_to_filename $DOCKER_IMAGE)

echo $(docker_img_from_yaml $WEAVE_NET_FILE 'weave-kube')
echo $(docker_img_from_yaml $WEAVE_NET_FILE 'weave-npc')

# echo $WEAVE_NET_FILE
