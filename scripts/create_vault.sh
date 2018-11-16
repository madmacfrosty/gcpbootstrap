#!/usr/bin/env sh

namespace="$1"

helm repo add banzaicloud-stable http://kubernetes-charts.banzaicloud.com/branch/master
helm install --tls --tiller-namespace="$1" --namespace="$1" banzaicloud-stable/vault-operator --set etcd-operator.enabled=true

{

cat > vault_crd.json <<EOF
apiVersion: "vault.banzaicloud.com/v1alpha1"
kind: "Vault"
metadata:
  name: "vault"
spec:
  size: 2
  image: vault:0.11.0
  bankVaultsImage: banzaicloud/bank-vaults:latest

  # This option gives us the option to workaround current StatefulSet limitations around updates
  # See: https://github.com/kubernetes/kubernetes/issues/67250
  # By default it is false.
  supportUpgrade: true

  # This option allows you to annotate the ETCD Cluster that Vault Operator creates.
  # It's specifically to annotate the ETCD Cluster as 'clusterwide' for a cluster wide
  # ETCD Operator, however it can be used to set any arbitrary annotations on the ETCD Cluster.
  # etcdAnnotations:
  #   etcd.database.coreos.com/scope: clusterwide
  
  # Describe where you would like to store the Vault unseal keys and root token.
  unsealConfig:
    kubernetes:
      secretNamespace: "$namespace"

  # A YAML representation of a final vault config file.
  # See https://www.vaultproject.io/docs/configuration/ for more information.
  config:
    storage:
      etcd:
        address: https://etcd-cluster:2379
        ha_enabled: "true"
    listener:
      tcp:
        address: "0.0.0.0:8200"
        tls_cert_file: /vault/tls/server.crt
        tls_key_file: /vault/tls/server.key
    api_addr: https://vault.default:8200
    telemetry:
      statsd_address: localhost:9125
    ui: true

  # See: https://github.com/banzaicloud/bank-vaults#example-external-vault-configuration for more details.
  externalConfig:
    policies:
    - name: allow_secrets
      rules: path "secret/*" {
              capabilities = ["create", "read", "update", "delete", "list"]
            }
    auth:
    - type: kubernetes
      roles:
        # Allow every pod in the default namespace to use the secret kv store
        - name: $namespace
          bound_service_account_names: default
          bound_service_account_namespaces: $namespace
          policies: allow_secrets
          ttl: 1h
EOF

}

kubectl apply -f vault_crd.json --namespace "$namespace"
rm vault_crd.json