#!/usr/bin/env sh

kubectl create clusterrolebinding tiller-cluster-admin-binding --clusterrole=cluster-admin --user="system:serviceaccount:$1:tiller"

