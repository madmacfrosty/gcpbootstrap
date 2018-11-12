#!/usr/bin/env sh

project="$1"
cluster="$2"
zone="$3"

gcloud components install --quiet kubectl
gcloud container clusters get-credentials "$cluster" --zone "$zone"
kubectl cluster-info