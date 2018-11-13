#!/usr/bin/env sh

{

cat > role.yaml <<EOF
kind: Role
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: tiller-manager
  namespace: $1
rules:
- apiGroups: ["", "extensions", "apps"]
  resources: ["*"]
  verbs: ["*"]
EOF

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
  kind: Role
  name: tiller-manager
  apiGroup: rbac.authorization.k8s.io  
EOF
  
kubectl create -f ./role.yaml
kubectl create -f ./binding.yaml
rm role.yaml binding.yaml
  
}

