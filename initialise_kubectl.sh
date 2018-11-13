#!/usr/bin/env sh

usage() {
  echo "$0 <project> <cluster> <zone>"
  exit 1
}

project="$1"
cluster="$2"
zone="$3"
if [ -z "$project" ]; then echo "project is unset" && usage; fi
if [ -z "$cluster" ]; then echo "cluster is unset" && usage; fi
if [ -z "$zone" ]; then echo "zone is unset" && usage; fi

gcloud components install --quiet kubectl
gcloud container clusters get-credentials "$cluster" --zone "$zone"
kubectl cluster-info
mkdir /certificates
cd /certificates
generate_ca.sh
generate_certificate.sh tiller
generate_certificate.sh helm

create_namespace.sh tillerworld
kubectl create sa tiller --namespace tillerworld
helm init --tiller-tls --tiller-tls-verify \
   --service-account=tiller \
   --tiller-namespace=tillerworld \
   --tiller-tls-cert ./tiller.pem \
   --tiller-tls-key ./tiller-key.pem \
   --tls-ca-cert ./ca.pem
   
cp ca.pem $(helm home)/ca.pem
cp helm.pem $(helm home)/cert.pem
cp helm-key.pem $(helm home)/key.pem

helm ls --tls --tls-namespace=tillerworld