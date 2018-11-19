#!/usr/bin/env sh

namespace="$1"

mkdir -p "/certificates/$namespace"
cd "/certificates/$namespace"

generate_certificate.sh tiller
generate_certificate.sh helm

create_namespace.sh "$namespace"
kubectl create sa tiller --namespace "$namespace"

if [ "$namespace" == "platform" ]; then
  authorise_clusteradmin_sa.sh "$namespace"
else
  authorise_edit_sa.sh "$namespace"
fi

# Try client only, copy certs and then install Tiller to avoid x509 error
helm init --tiller-tls --tiller-tls-verify --wait \
   --service-account=tiller \
   --tiller-namespace="$namespace" \
   --tiller-tls-cert ./tiller.pem \
   --tiller-tls-key ./tiller-key.pem \
   --tls-ca-cert ../ca.pem
   
cp ../ca.pem $(helm home)/ca.pem
cp helm.pem $(helm home)/cert.pem
cp helm-key.pem $(helm home)/key.pem

sleep 5
helm version --tls --tiller-namespace="$namespace"