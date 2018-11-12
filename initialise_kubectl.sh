#!/usr/bin/env sh

usage() {
  echo "$0 <project> <cluster> <zone>"
  exit 1
}

project="$1"
cluster="$2"
zone="$3"
if [ -z "$project" ]; then echo "project is unset" && usage; fi
if [ -z "$cluster" ]; then echo "cluster is unset" && usage; fi
if [ -z "$zone" ]; then echo "zone is unset" && usage; fi

gcloud components install --quiet kubectl
gcloud container clusters get-credentials "$cluster" --zone "$zone"
kubectl cluster-info
