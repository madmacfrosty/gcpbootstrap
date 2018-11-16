
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
kubectl apply -f deployment.yaml -n $1
kubectl apply -f vault.yaml -n $1

}
