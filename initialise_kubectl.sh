#!/usr/bin/env sh

usage() {
  echo "$0 <project> <cluster> <zone> <admin_password>"
  exit 1
}

project="$1"
cluster="$2"
zone="$3"
password="$4"
if [ -z "$project" ]; then echo "project is unset" && usage; fi
if [ -z "$cluster" ]; then echo "cluster is unset" && usage; fi
if [ -z "$zone" ]; then echo "zone is unset" && usage; fi
if [ -z "$password" ]; then echo "Admin password is unset" && usage; fi

gcloud components install --quiet kubectl
gcloud container clusters get-credentials "$cluster" --zone "$zone"
kubectl config set-credentials "admin/$cluster" --username=admin --password="$password"
kubectl config set-context sysadmin --user="admin/$cluster" --cluster="gke_${project}_${zone}_${cluster}"
kubectl config use-context sysadmin
kubectl cluster-info
