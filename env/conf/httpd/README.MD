# For new cert generation, please execute the following commands, from the current dir.
```
mkdir -p ssl/magento1 ssl/magento2
openssl genrsa -out ssl/server.key 2048
openssl req -subj '/C=US/ST=California/L=Magento Team city/O=Magento Inc./OU=Magento Team/CN=*.*/emailAddress=team@magento.com' -new -key ssl/server.key -out ssl/wildcard.csr
openssl req -subj '/C=US/ST=California/L=Magento Team city/O=Magento Inc./OU=Magento Team/CN=*.magento1.local/emailAddress=team@magento.com' -new -key ssl/server.key -out ssl/magento1/server.csr
openssl req -subj '/C=US/ST=California/L=Magento Team city/O=Magento Inc./OU=Magento Team/CN=*.magento2.local/emailAddress=team@magento.com' -new -key ssl/server.key -out ssl/magento2/server.csr
openssl x509 -req -days 365 -in ssl/wildcard.csr -signkey ssl/server.key -out ssl/wildcard.crt
openssl x509 -req -days 365 -in ssl/magento1/server.csr -signkey ssl/server.key -out ssl/magento1/server.crt
openssl x509 -req -days 365 -in ssl/magento2/server.csr -signkey ssl/server.key -out ssl/magento2/server.crt
```
