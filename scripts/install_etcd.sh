#!/usr/bin/env sh
helm install --tls --tiller-namespace="$1" --namespace="$1" stable/etcd-operator --name etcd-operator-release
