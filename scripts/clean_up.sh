#!/usr/bin/env sh

kubectl delete namespace platform
kubectl delete clusterrole my-release-etcd-operator-etcd-operator
kubectl delete clusterrolebinding tiller-cluster-admin-binding
kubectl delete clusterrolebinding my-release-etcd-operator-etcd-backup-operator
kubectl delete clusterrolebinding my-release-etcd-operator-etcd-operator
kubectl delete clusterrolebinding my-release-etcd-operator-etcd-restore-operator
kubectl delete crd etcdbackups.etcd.database.coreos.com
kubectl delete crd etcdclusters.etcd.database.coreos.com
kubectl delete crd etcdrestores.etcd.database.coreos.com
