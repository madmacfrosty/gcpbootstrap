#!/usr/bin/env sh

mkdir helm
cd helm

cat <<EOF | cfssl genkey - | cfssljson -bare tiller
  "CN": "tiller",
  "key": {
    "algo": "ecdsa",
    "size": 256
  }
}
EOF

cat <<EOF | kubectl create -f -
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: tiller.tillerworld
spec:
  groups:
  - system:authenticated
  request: $(cat tiller.csr | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF

kubectl certificate approve tiller.tillerworld

# helm init --tiller-tls --tiller-tls-verify \
          # --tiller-namespace=tillerworld \
		  # --service-account=tiller \
          # --tiller-tls-cert ./tiller.cert.pem \
		  # --tiller-tls-key ./tiller-key.pem \
		  # --tls-ca-cert ca.cert.pem \

