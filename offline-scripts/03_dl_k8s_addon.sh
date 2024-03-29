#!/bin/bash

NEW_REGISTRY=docker.artifact.boonlogic.io/k8s
DL_IMAGE_PATH=binaries/k8s_addons
DL_YAML_PATH=$PWD/binaries/yaml
DL_PATH=$PWD/$DL_IMAGE_PATH
mkdir -p $DL_PATH
mkdir -p $DL_YAML_PATH

K8S_STABLE_VERSION=$(curl -s -k https://storage.googleapis.com/kubernetes-release/release/stable.txt)
echo "Using latest Kubernetes stable version: $K8S_STABLE_VERSION"
# echo "Kubectl version: $(kubectl version)"

docker_img_from_yaml() {
  local IMAGE_LINE=$(curl -s -k $1 | grep $2)
  local IMAGE_TAG="${IMAGE_LINE##* }"
  IMAGE_TAG=$(echo $IMAGE_TAG | xargs)
  # echo $IMAGE_LINE
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

K8S_DASHBOARD_FILE="https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml"
DASHBOARD_IMAGE=$(docker_img_from_yaml $K8S_DASHBOARD_FILE 'kubernetes-dashboard-amd64')
#echo $DASHBOARD_IMAGE
#echo $(img_to_filename $DASHBOARD_IMAGE)

# K8S_VER_ID=$(kubectl version | base64 | tr -d '\n')
K8S_VER_ID="Q2xpZW50IFZlcnNpb246IHZlcnNpb24uSW5mb3tNYWpvcjoiMSIsIE1pbm9yOiIxNSIsIEdpdFZlcnNpb246InYxLjE1LjAiLCBHaXRDb21taXQ6ImU4NDYyYjViNWRjMjU4NGZkY2QxOGU2YmNmZTlmMWU0ZDk3MGE1MjkiLCBHaXRUcmVlU3RhdGU6ImNsZWFuIiwgQnVpbGREYXRlOiIyMDE5LTA2LTE5VDE2OjQwOjE2WiIsIEdvVmVyc2lvbjoiZ28xLjEyLjUiLCBDb21waWxlcjoiZ2MiLCBQbGF0Zm9ybToibGludXgvYW1kNjQifQpTZXJ2ZXIgVmVyc2lvbjogdmVyc2lvbi5JbmZve01ham9yOiIxIiwgTWlub3I6IjE1IiwgR2l0VmVyc2lvbjoidjEuMTUuMCIsIEdpdENvbW1pdDoiZTg0NjJiNWI1ZGMyNTg0ZmRjZDE4ZTZiY2ZlOWYxZTRkOTcwYTUyOSIsIEdpdFRyZWVTdGF0ZToiY2xlYW4iLCBCdWlsZERhdGU6IjIwMTktMDYtMTlUMTY6MzI6MTRaIiwgR29WZXJzaW9uOiJnbzEuMTIuNSIsIENvbXBpbGVyOiJnYyIsIFBsYXRmb3JtOiJsaW51eC9hbWQ2NCJ9Cg=="

############
# Pod Networks
############

## Before installing Weave Net, you should make sure the following ports are not blocked by your firewall:
## TCP 6783 and UDP 6783/6784. For more details, see the FAQ.
WEAVE_NET_FILE="https://cloud.weave.works/k8s/net?k8s-version=$K8S_VER_ID"
WEAVE_NET_FILE="https://cloud.weave.works/k8s/v1.10/net.yaml"

WEAVE_KUBE_IMAGE=$(docker_img_from_yaml $WEAVE_NET_FILE 'weave-kube')
WEAVE_NPC_IMAGE=$(docker_img_from_yaml $WEAVE_NET_FILE 'weave-npc')

FLANNEL_FILE="https://raw.githubusercontent.com/coreos/flannel/62e44c867a2846fefb68bd5f178daf4da3095ccb/Documentation/kube-flannel.yml"
FLANNEL_IMAGES=(
"quay.io/coreos/flannel:v0.11.0-amd64"
"quay.io/coreos/flannel:v0.11.0-arm64"
"quay.io/coreos/flannel:v0.11.0-arm"
"quay.io/coreos/flannel:v0.11.0-ppc64le"
"quay.io/coreos/flannel:v0.11.0-s390x"
)

PROM_OPER_FILE="https://raw.githubusercontent.com/coreos/prometheus-operator/master/bundle.yaml"
PROM_OPER_IMAGE="quay.io/coreos/prometheus-operator:v0.31.1"
PROM_OPER_IMAGE_30="quay.io/coreos/prometheus-operator:v0.30.0"
PROM_OPER_CONFIGMAP_RELOAD_IMAGE="quay.io/coreos/configmap-reload:v0.0.1"
PROM_OPER_CONFIG_RELOADER_IMAGE="quay.io/coreos/prometheus-config-reloader:v0.31.1"

K8S_PROM_OPER_IMAGES=(
$PROM_OPER_IMAGE_30
$PROM_OPER_IMAGE
$PROM_OPER_CONFIGMAP_RELOAD_IMAGE
$PROM_OPER_CONFIG_RELOADER_IMAGE
"k8s.gcr.io/addon-resizer:1.8.4"
"quay.io/coreos/kube-rbac-proxy:v0.4.1"
"quay.io/coreos/kube-state-metrics:v1.5.0"
"quay.io/prometheus/node-exporter:v0.18.1"
"quay.io/prometheus/prometheus:v2.10.0"
"quay.io/prometheus/alertmanager:v0.17.0")
# git clone https://github.com/coreos/kube-prometheus.git

METALLB_FILE="https://raw.githubusercontent.com/google/metallb/v0.8.0/manifests/metallb.yaml"
METALLB_SPEAKER_IMAGE=$(docker_img_from_yaml $METALLB_FILE 'metallb/speaker')
METALLB_CTRL_IMAGE=$(docker_img_from_yaml $METALLB_FILE 'metallb/controller')

#########################
# D/L and prepare setup
#########################

IMAGE_LIST=($DASHBOARD_IMAGE $WEAVE_KUBE_IMAGE $WEAVE_NPC_IMAGE $PROM_OPER_IMAGE $PROM_OPER_CONFIGMAP_RELOAD_IMAGE $PROM_OPER_CONFIG_RELOADER_IMAGE) 
IMAGE_LIST=("${IMAGE_LIST[@]}" "${FLANNEL_IMAGES[@]}" "${K8S_PROM_OPER_IMAGES[@]}" $METALLB_SPEAKER_IMAGE $METALLB_CTRL_IMAGE)

YAML_FILE_LIST=($K8S_DASHBOARD_FILE $WEAVE_NET_FILE $PROM_OPER_FILE $FLANNEL_FILE $METALLB_FILE)
# echo ${IMAGE_LIST[*]}
# echo ${YAML_FILE_LIST[*]}

for YAML in ${YAML_FILE_LIST[@]}
do
  curl $YAML -s -k -O
done
mv *.yaml $DL_YAML_PATH
mv *.yml $DL_YAML_PATH

# generate the loading script for k8s addons
echo "#!/bin/bash" > load_k8s_addons_images.sh
echo "" >> load_k8s_addons_images.sh

for IMAGE in ${IMAGE_LIST[@]}
do
  docker pull $IMAGE
  docker save -o $DL_IMAGE_PATH/$(img_to_filename $IMAGE) $IMAGE
  echo "docker load -i $DL_IMAGE_PATH/$(img_to_filename $IMAGE)" >> load_k8s_addons_images.sh
done

echo "" >> load_k8s_addons_images.sh
for IMAGE in ${IMAGE_LIST[@]}
do
  echo "docker tag $IMAGE $(img_switch_registry_tag $IMAGE $NEW_REGISTRY)" >> load_k8s_addons_images.sh
done

echo "" >> load_k8s_addons_images.sh
for IMAGE in ${IMAGE_LIST[@]}
do
  echo "docker push $(img_switch_registry_tag $IMAGE $NEW_REGISTRY)" >> load_k8s_addons_images.sh
done


