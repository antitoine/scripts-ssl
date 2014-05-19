#!/bin/sh
# Generation of a new SSL certificat signed by the CA Antoine CHABERT

CADIR="/etc/ssl/ca/"
SSLDIR="/etc/ssl/"

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

case "$1" in
    -n | --name)
        cd ${CADIR}
        mv private/${2}.key private/${2}-old.key
        mv req/${2}.req req/${2}-old.req
        openssl genrsa -aes256 -out private/${2}.key 2048
        openssl req -sha256 -new -key private/${2}.key -out req/${2}.req -config openssl.cnf
        openssl ca -days 365 -in req/${2}.req -out certs/${2}.pem -config ./openssl.cnf
        mv certs/${2}.pem ${SSLDIR}certs/
        cp private/${2}.key ${SSLDIR}private/
        ;;
    *)
        echo "Usage: $0 {-n|--name} CERTNAME"
        ;;
esac
