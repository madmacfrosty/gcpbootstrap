#!/usr/bin/env sh

kubectl create rolebinding test-binding --clusterrole=cluster-admin --serviceaccount="$1:tiller" --namespace="$1"


