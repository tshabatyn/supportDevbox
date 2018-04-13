#!/bin/bash

mkdir -p ssl/root

cat << EOF > ssl/wildcard.ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = magento1.local
DNS.2 = *.magento1.local
DNS.3 = magento2.local
DNS.4 = *.magento2.local
DNS.5 = xhgui.local

EOF

openssl genrsa -des3 -out ssl/root/CA.key 2048
openssl req -x509 -new -nodes -key ssl/root/CA.key -sha256 -days 1825 -out ssl/root/CA.pem -subj '/C=US/ST=California/L=Magento Team city/O=Magento Inc./OU=Magento Team/CN=Magento Devbox/emailAddress=team@magento.com'

openssl genrsa -out ssl/wildcard.key 2048
openssl req -new -key ssl/wildcard.key -out ssl/wildcard.csr -subj '/C=US/ST=California/L=Magento Team city/O=Magento Inc./OU=Magento Team/CN=Magento Devbox Wildcart/emailAddress=team@magento.com'
openssl x509 -req -in ssl/wildcard.csr -CA ssl/root/CA.pem -CAkey ssl/root/CA.key -CAcreateserial -out ssl/wildcard.crt -days 1825 -sha256 -extfile ssl/wildcard.ext

rm ssl/wildcard.ext
