#!/usr/bin/env sh

{

cat > binding.yaml <<EOF
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: tiller-binding
  namespace: $1
subjects:
- kind: ServiceAccount
  name: tiller
  namespace: $1
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
EOF
  
kubectl create -f ./binding.yaml -n "$1"
rm binding.yaml
}

