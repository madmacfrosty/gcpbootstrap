#!/usr/bin/env sh

{

namespace="$1"

cat > "$namespace-csr.json" <<EOF
{
  "CN": "$namespace",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "UK",
      "L": "Edinburgh",
      "O": "system:masters",
      "OU": "$namespace"      
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  "$namespace-csr.json" | cfssljson -bare "$namespace"

}