#!/usr/bin/env sh

cd /certificates

{

cat > "$1-csr.json" <<EOF
{
  "CN": \""$1"\",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "UK",
      "L": "Edinburgh",
      "O": "system:masters",
      "OU": \""$1"\"      
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  "$1-csr.json" | cfssljson -bare "$1"

}