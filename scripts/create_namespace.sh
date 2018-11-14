#!/usr/bin/env sh
{

cat > "namespace-$1.json" <<EOF
{
  "kind": "Namespace",
  "apiVersion": "v1",
  "metadata": {
    "name": "$1",
    "labels": {
      "name": "$1"
    }
  }
}
EOF

kubectl create -f "./namespace-$1.json"
rm "./namespace-$1.json"

}