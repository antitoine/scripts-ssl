#!/bin/sh
# Generation of a new SSL certificat signed by the CA Antoine CHABERT

SSLCERTDIR="/etc/ssl/certs"
SSLPRIVATEDIR="/etc/ssl/private"

CONFFILS="/etc/ssl/ca/openssl.cnf"

CACERTDIR="/etc/ssl/ca/certs"
CAPRIVATEDIR="/etc/ssl/ca/private"
CAREQDIR="/etc/ssl/ca/req"

OLDCERTDIR="/etc/ssl/ca/old-certs"
OLDPRIVATEDIR="/etc/ssl/ca/old-private"
OLDREQDIR="/etc/ssl/ca/old-req"

DATE=$(date +"%Y%m%d%H%M")
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"
ROUGE="\\033[1;31m"
ROSE="\\033[1;35m"
BLEU="\\033[1;34m"
BLANC="\\033[0;02m"
BLANCLAIR="\\033[1;08m"
JAUNE="\\033[1;33m"
CYAN="\\033[1;36m"

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo -e "$ROUGE""Ce script doit être lancé en root (avec les droits administrateurs)" 1>&2
   exit 1
fi

case "$1" in
    -n | --name)
        if [ -f $CAPRIVATEDIR/$2.key ]; then
            echo "$NORMAL""Déplacement de l'ancienne clé privée (""$ROSE""$CAPRIVATEDIR/$2.key""$NORMAL"" vers ""$ROSE""$OLDPRIVATEDIR/$2-$DATE.key""$NORMAL"") : "
            mv $CAPRIVATEDIR/$2.key $OLDPRIVATEDIR/$2-$DATE.key
            echo "$VERT""Ok\n"
        fi

        if [ -f $CAREQDIR/$2.req ]; then
            echo "$NORMAL""Déplacement de l'ancienne requête (""$ROSE""$CAREQDIR/$2.req""$NORMAL"" vers ""$ROSE""$OLDREQDIR/$2-$DATE.req""$NORMAL"") : "
            mv $CAREQDIR/$2.req $OLDREQDIR/$2-$DATE.req
            echo "$VERT""Ok\n"
        fi

        if [ -f $SSLCERTDIR/$2.pem ]; then
            echo "$NORMAL""Déplacement de l'ancien certificat (""$ROSE""$SSLCERTDIR/$2.pem""$NORMAL"" vers ""$ROSE""$OLDCERTDIR/$2-$DATE.pem""$NORMAL"") : "
            mv $SSLCERTDIR/$2.pem $OLDCERTDIR/$2-$DATE.pem
            echo "$VERT""Ok\n"
        fi

        echo "$NORMAL""Création de la nouvelle clé privée (""$ROSE""$CAPRIVATEDIR/$2.key""$NORMAL"") : "
        openssl genrsa -aes256 -out $CAPRIVATEDIR/$2.key 2048
        echo "$VERT""Ok\n"

        echo "$NORMAL""Création de la nouvelle requête (""$ROSE""$CAREQDIR/$2.req""$NORMAL"") : "
        openssl req -sha256 -new -key $CAPRIVATEDIR/$2.key -out $CAREQDIR/$2.req -config $CONFFILS
        echo "$VERT""Ok\n"

        echo "$NORMAL""Création du certificat et validation de celui-ci par le CA (""$ROSE""$SSLCERTDIR/$2.pem""$NORMAL"" et copie du nouveau certificat dans ""$ROSE""$CACERTDIR/""$NORMAL"") : "
        openssl ca -days 365 -in $CAREQDIR/$2.req -out $SSLCERTDIR/$2.pem -config $CONFFILS
        echo "$VERT""Ok\n"

        echo "$NORMAL""Copie de la clé privée vers le dossier SSL (dans ""$ROSE""$SSLPRIVATEDIR/$2.key""$NORMAL"") : "
        cp $CAPRIVATEDIR/$2.key $SSLPRIVATEDIR/$2.key
        echo "$VERT""Ok\n"

        echo "$NORMAL""Génération du certificat ""$CYAN""$2""$NORMAL"" terminée"
        ;;
    *)
        echo "Usage: $0 {-n|--name} CERTNAME"
        ;;
esac
