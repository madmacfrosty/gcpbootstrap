#!/usr/bin/env sh

usage() {
  echo "$0 <cluster> <zone>"
  exit 1
}

cluster="$1"
zone="$2"
if [ -z "$cluster" ]; then echo "cluster is unset" && usage; fi
if [ -z "$zone" ]; then echo "zone is unset" && usage; fi

gcloud components install --quiet kubectl
gcloud container clusters get-credentials "$cluster" --zone "$zone"
kubectl cluster-info
