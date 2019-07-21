#!/bin/bash

docker load -i binaries/k8s_addons/kubernetes-dashboard-amd64_v1.10.1.tar
docker load -i binaries/k8s_addons/weave-kube_2.5.2.tar
docker load -i binaries/k8s_addons/weave-npc_2.5.2.tar
docker load -i binaries/k8s_addons/prometheus-operator_v0.31.1.tar
docker load -i binaries/k8s_addons/configmap-reload_v0.0.1.tar
docker load -i binaries/k8s_addons/prometheus-config-reloader_v0.31.1.tar
docker load -i binaries/k8s_addons/flannel_v0.11.0-amd64.tar
docker load -i binaries/k8s_addons/flannel_v0.11.0-arm64.tar
docker load -i binaries/k8s_addons/flannel_v0.11.0-arm.tar
docker load -i binaries/k8s_addons/flannel_v0.11.0-ppc64le.tar
docker load -i binaries/k8s_addons/flannel_v0.11.0-s390x.tar
docker load -i binaries/k8s_addons/prometheus-operator_v0.30.0.tar
docker load -i binaries/k8s_addons/prometheus-operator_v0.31.1.tar
docker load -i binaries/k8s_addons/configmap-reload_v0.0.1.tar
docker load -i binaries/k8s_addons/prometheus-config-reloader_v0.31.1.tar
docker load -i binaries/k8s_addons/addon-resizer_1.8.4.tar
docker load -i binaries/k8s_addons/kube-rbac-proxy_v0.4.1.tar
docker load -i binaries/k8s_addons/kube-state-metrics_v1.5.0.tar
docker load -i binaries/k8s_addons/node-exporter_v0.18.1.tar
docker load -i binaries/k8s_addons/prometheus_v2.10.0.tar
docker load -i binaries/k8s_addons/alertmanager_v0.17.0.tar
docker load -i binaries/k8s_addons/speaker_v0.8.0.tar
docker load -i binaries/k8s_addons/controller_v0.8.0.tar

docker tag k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.1 docker.artifact.boonlogic.io/k8s/kubernetes-dashboard-amd64:v1.10.1
docker tag docker.io/weaveworks/weave-kube:2.5.2 docker.artifact.boonlogic.io/k8s/weave-kube:2.5.2
docker tag docker.io/weaveworks/weave-npc:2.5.2 docker.artifact.boonlogic.io/k8s/weave-npc:2.5.2
docker tag quay.io/coreos/prometheus-operator:v0.31.1 docker.artifact.boonlogic.io/k8s/prometheus-operator:v0.31.1
docker tag quay.io/coreos/configmap-reload:v0.0.1 docker.artifact.boonlogic.io/k8s/configmap-reload:v0.0.1
docker tag quay.io/coreos/prometheus-config-reloader:v0.31.1 docker.artifact.boonlogic.io/k8s/prometheus-config-reloader:v0.31.1
docker tag quay.io/coreos/flannel:v0.11.0-amd64 docker.artifact.boonlogic.io/k8s/flannel:v0.11.0-amd64
docker tag quay.io/coreos/flannel:v0.11.0-arm64 docker.artifact.boonlogic.io/k8s/flannel:v0.11.0-arm64
docker tag quay.io/coreos/flannel:v0.11.0-arm docker.artifact.boonlogic.io/k8s/flannel:v0.11.0-arm
docker tag quay.io/coreos/flannel:v0.11.0-ppc64le docker.artifact.boonlogic.io/k8s/flannel:v0.11.0-ppc64le
docker tag quay.io/coreos/flannel:v0.11.0-s390x docker.artifact.boonlogic.io/k8s/flannel:v0.11.0-s390x
docker tag quay.io/coreos/prometheus-operator:v0.30.0 docker.artifact.boonlogic.io/k8s/prometheus-operator:v0.30.0
docker tag quay.io/coreos/prometheus-operator:v0.31.1 docker.artifact.boonlogic.io/k8s/prometheus-operator:v0.31.1
docker tag quay.io/coreos/configmap-reload:v0.0.1 docker.artifact.boonlogic.io/k8s/configmap-reload:v0.0.1
docker tag quay.io/coreos/prometheus-config-reloader:v0.31.1 docker.artifact.boonlogic.io/k8s/prometheus-config-reloader:v0.31.1
docker tag k8s.gcr.io/addon-resizer:1.8.4 docker.artifact.boonlogic.io/k8s/addon-resizer:1.8.4
docker tag quay.io/coreos/kube-rbac-proxy:v0.4.1 docker.artifact.boonlogic.io/k8s/kube-rbac-proxy:v0.4.1
docker tag quay.io/coreos/kube-state-metrics:v1.5.0 docker.artifact.boonlogic.io/k8s/kube-state-metrics:v1.5.0
docker tag quay.io/prometheus/node-exporter:v0.18.1 docker.artifact.boonlogic.io/k8s/node-exporter:v0.18.1
docker tag quay.io/prometheus/prometheus:v2.10.0 docker.artifact.boonlogic.io/k8s/prometheus:v2.10.0
docker tag quay.io/prometheus/alertmanager:v0.17.0 docker.artifact.boonlogic.io/k8s/alertmanager:v0.17.0
docker tag metallb/speaker:v0.8.0 docker.artifact.boonlogic.io/k8s/speaker:v0.8.0
docker tag metallb/controller:v0.8.0 docker.artifact.boonlogic.io/k8s/controller:v0.8.0

docker push docker.artifact.boonlogic.io/k8s/kubernetes-dashboard-amd64:v1.10.1
docker push docker.artifact.boonlogic.io/k8s/weave-kube:2.5.2
docker push docker.artifact.boonlogic.io/k8s/weave-npc:2.5.2
docker push docker.artifact.boonlogic.io/k8s/prometheus-operator:v0.31.1
docker push docker.artifact.boonlogic.io/k8s/configmap-reload:v0.0.1
docker push docker.artifact.boonlogic.io/k8s/prometheus-config-reloader:v0.31.1
docker push docker.artifact.boonlogic.io/k8s/flannel:v0.11.0-amd64
docker push docker.artifact.boonlogic.io/k8s/flannel:v0.11.0-arm64
docker push docker.artifact.boonlogic.io/k8s/flannel:v0.11.0-arm
docker push docker.artifact.boonlogic.io/k8s/flannel:v0.11.0-ppc64le
docker push docker.artifact.boonlogic.io/k8s/flannel:v0.11.0-s390x
docker push docker.artifact.boonlogic.io/k8s/prometheus-operator:v0.30.0
docker push docker.artifact.boonlogic.io/k8s/prometheus-operator:v0.31.1
docker push docker.artifact.boonlogic.io/k8s/configmap-reload:v0.0.1
docker push docker.artifact.boonlogic.io/k8s/prometheus-config-reloader:v0.31.1
docker push docker.artifact.boonlogic.io/k8s/addon-resizer:1.8.4
docker push docker.artifact.boonlogic.io/k8s/kube-rbac-proxy:v0.4.1
docker push docker.artifact.boonlogic.io/k8s/kube-state-metrics:v1.5.0
docker push docker.artifact.boonlogic.io/k8s/node-exporter:v0.18.1
docker push docker.artifact.boonlogic.io/k8s/prometheus:v2.10.0
docker push docker.artifact.boonlogic.io/k8s/alertmanager:v0.17.0
docker push docker.artifact.boonlogic.io/k8s/speaker:v0.8.0
docker push docker.artifact.boonlogic.io/k8s/controller:v0.8.0
