#!/usr/bin/env sh

{

usage() {
  echo "$0 <user-1> ... <user-N>"
  exit 1
}

if [ -z "$1" ]; then echo "user is unset" && usage; fi

for user in $@;
do
  cat > "clusteradmin_${user}_binding.yaml" <<EOF
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: clusteradmin_$1
subjects:
- kind: User
  name: $1
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
EOF

  kubectl apply -f "clusteradmin_${user}_binding.yaml"
done
}