#!/bin/bash

if [ $# -ne 1 ]; then
    cat <<EOF
Usage: $0 FQDN
EOF
    exit 1
fi

FQDN=$1

if [ $FQDN == "-l" ]; then
    certutil -L -d sql:$HOME/.pki/nssdb
    exit 0
fi

if [ -f $FQDN/$FQDN.crt ]; then
    certutil -d sql:$HOME/.pki/nssdb -A -t TC -n "$FQDN" -i $FQDN/$FQDN.crt
else
    echo -e "ERROR: not certificate found.\nPlease run 'certgen.sh' to generate a certificate."
fi
