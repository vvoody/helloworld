#/bin/bash

# http://wiki.nginx.org/HttpSslModule

if [ $# -ne 1 ]; then
    cat <<EOF
Usage: $0 FQDN
EOF
    exit 1
fi

FQDN=$1

mkdir $FQDN
cd $FQDN
openssl genrsa -des3 -out $FQDN.key 1024
openssl req -new -key $FQDN.key -out $FQDN.csr
cp $FQDN.key $FQDN.key.org
openssl rsa -in $FQDN.key.org -out $FQDN.key
openssl x509 -req -days 365 -in $FQDN.csr -signkey $FQDN.key -out $FQDN.crt
