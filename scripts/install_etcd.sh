#!/usr/bin/env sh

{

helm install --tls --tiller-namespace=$1 --namespace=$1 \
  stable/etcd-operator --name etcd-release --set etcdOperator.commandArgs.cluster-wide=true

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

cat > nodeport_service.json <<EOF
{
    "kind": "Service",
    "apiVersion": "v1",
    "metadata": {
        "name": "etcd-cluster-client-service"
    },
    "spec": {
        "selector": {
            "etcd_cluster": "etcd-cluster",
            "app": "etcd"
        },
        "ports": [
            {
                "protocol": "TCP",
                "port": 2379,
                "targetPort": 2379,
                "nodePort": 32379
            }
        ],
        "type": "NodePort"
    }
}
EOF


kubectl apply -f cluster.yaml --namespace $1

}