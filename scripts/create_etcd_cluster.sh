#!/usr/bin/env sh

{

cat > cluster.yaml <<EOF
apiVersion: "etcd.database.coreos.com/v1beta2"
kind: "EtcdCluster"
metadata:
  name: "etcd-cluster"
  annotations:
    etcd.database.coreos.com/scope: clusterwide
spec:
  size: 3
  version: "3.2.13"
EOF

kubectl apply -f cluster.yaml --namespace "$1"

}
