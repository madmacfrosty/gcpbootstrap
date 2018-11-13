#!/usr/bin/env sh

mkdir /certificates
cd /certificates
generate_ca.sh
generate_certificate.sh tiller
generate_certificate.sh helm

create_namespace.sh "$1"
kubectl create sa tiller --namespace "$1"
helm init --tiller-tls --tiller-tls-verify \
   --service-account=tiller \
   --tiller-namespace="$1" \
   --tiller-tls-cert ./tiller.pem \
   --tiller-tls-key ./tiller-key.pem \
   --tls-ca-cert ./ca.pem
   
cp ca.pem $(helm home)/ca.pem
cp helm.pem $(helm home)/cert.pem
cp helm-key.pem $(helm home)/key.pem

authorise_sa.sh "$1"

helm ls --tls --tiller-namespace="$1"