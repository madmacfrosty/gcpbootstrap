
{

cat > vault_crd.yaml <<EOF
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  name: vaultservices.vault.security.coreos.com
spec:
  group: vault.security.coreos.com
  names:
    kind: VaultService
    listKind: VaultServiceList
    plural: vaultservices
    shortNames:
    - vault
    singular: vaultservice
  scope: Namespaced
  version: v1alpha1
EOF

cat > deployment.yaml <<EOF
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: vault-operator
spec:
  replicas: 1
  template:
    metadata:
      labels:
        name: vault-operator
    spec:
	  serviceAccountName: vault-operator
      containers:
      - name: vault-operator
        image: quay.io/coreos/vault-operator:latest
        env:
        - name: MY_POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: MY_POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
EOF

cat > rbac.yaml <<EOF
kind: Role
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: vault-operator-role
rules:
- apiGroups:
  - etcd.database.coreos.com
  resources:
  - etcdclusters
  - etcdbackups
  - etcdrestores
  verbs:
  - "*"
- apiGroups:
  - vault.security.coreos.com
  resources:
  - vaultservices
  verbs:
  - "*"
- apiGroups:
  - storage.k8s.io
  resources:
  - storageclasses
  verbs:
  - "*"
- apiGroups:
  - "" # "" indicates the core API group
  resources:
  - pods
  - services
  - endpoints
  - persistentvolumeclaims
  - events
  - configmaps
  - secrets
  verbs:
  - "*"
- apiGroups:
  - apps
  resources:
  - deployments
  verbs:
  - "*"

---

kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: vault-operator-rolebinding
subjects:
- kind: ServiceAccount
  name: vault-operator
  namespace: $1
roleRef:
  kind: Role
  name: vault-operator-role
  apiGroup: rbac.authorization.k8s.io
EOF


cat > vault.yaml <<EOF
apiVersion: "vault.security.coreos.com/v1alpha1"
kind: "VaultService"
metadata:
  name: "platform-vault"
spec:
  nodes: 2
  version: "0.9.1-0"
EOF

kubectl apply -f vault_crd.yaml -n $1
kubectl apply -f rbac.yaml -n $1
kubectl apply -f deployment.yaml -n $1
kubectl apply -f vault.yaml -n $1

}
