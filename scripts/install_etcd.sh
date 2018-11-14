#!/usr/bin/env sh
helm --tls --tiller-namespace="$1" stable/etcd-operator --name etcd-operator-release
