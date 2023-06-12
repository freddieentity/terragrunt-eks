#!/bin/bash
kubectl -n default get secret freddieentity-link-key-pair -o jsonpath="{.data.tls\.cert}" | base64 --decode
echo "base64" | base64 -d -o ca.crt
openssl x509 -in ca.crt -text -noout