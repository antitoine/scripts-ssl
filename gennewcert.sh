#!/bin/sh
# Generation of a new SSL certificat signed by the CA Antoine CHABERT

################### Configuration ######################

## Chemin vers le dossier contenant les certificats
SSLCERTDIR="/etc/ssl/certs"
## Chemin vers le dossier contenant les clés privées
SSLPRIVATEDIR="/etc/ssl/private"

## Chemin vers le fichier de préconfiguration openssl
CONFFILS="/etc/ssl/ca/openssl.cnf"

## Chemin vers le dossier contenant les certificats générés et validés par le CA
CACERTDIR="/etc/ssl/ca/certs"
## Chemin vers le dossier contenant les clés privées générés et validés par le CA
CAPRIVATEDIR="/etc/ssl/ca/private"
## Chemin vers le dossier contenant les requêtes pour validation par le CA
CAREQDIR="/etc/ssl/ca/req"

## Chemin vers le dossier contenant les anciens certificats (revoqués)
OLDCERTDIR="/etc/ssl/ca/old-certs"
## Chemin vers le dossier contenant les anciennes clés privées (révoquées)
OLDPRIVATEDIR="/etc/ssl/ca/old-private"
## Chemin vers le dossier contenant les requêtes des anciens certificats (révoqués)
OLDREQDIR="/etc/ssl/ca/old-req"

#########################################################

## Variables générales
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

## Fonctions générales
execute() {
    if [ -z "$1" ]; then 
        echo "L'argument de la commande à exécuter n'est pas présent !";
    else
        (eval "$1" && echo "$VERT"" ok\n""$NORMAL" && return 0) || (echo "$ROUGE"" ko\n""$NORMAL" && return 1) ;
    fi
}

check_certname() {
    if [ -z "$1" ]; then 
        echo "Le nom du certificat est obligatoire (CERTNAME) !"
        exit 1
    else
        CERTNAME=$1
    fi
}

revoke() {
    check_certname $1

    echo "Révocation du certificat $CYAN""$CERTNAME""$NORMAL ..."
    
    if [ -f $SSLCERTDIR/$CERTNAME.pem ]; then
        echo "Révocation du certificat $CERTNAME.pem : "
        execute "openssl ca -revoke $SSLCERTDIR/$CERTNAME.pem -config $CONFFILS" || (echo "Mauvaise pass-phrase" ; exit 1)
        echo "Déplacement de l'ancien certificat (""$ROSE""$SSLCERTDIR/$CERTNAME.pem""$NORMAL"" vers ""$ROSE""$OLDCERTDIR/$CERTNAME-$DATE.pem""$NORMAL"") : "
        execute "mv $SSLCERTDIR/$CERTNAME.pem $OLDCERTDIR/$CERTNAME-$DATE.pem"
    else
        echo "$ROUGE""Il n'existe pas de certificat avec ce nom : $ROSE""$SSLCERTDIR/$CERTNAME.pem"
        exit 1
    fi

    if [ -f $SSLPRIVATEDIR/$CERTNAME.key ]; then
        echo "Suppression de la copie de l'ancienne clé privée (""$ROSE""$SSLPRIVATEDIR/$CERTNAME.key""$NORMAL"") : "
        execute "rm -i $SSLPRIVATEDIR/$CERTNAME.key"
    fi

    if [ -f $CAPRIVATEDIR/$CERTNAME.key ]; then
        echo "Déplacement de l'ancienne clé privée (""$ROSE""$CAPRIVATEDIR/$CERTNAME.key""$NORMAL"" vers ""$ROSE""$OLDPRIVATEDIR/$CERTNAME-$DATE.key""$NORMAL"") : "
        execute "mv -i $CAPRIVATEDIR/$CERTNAME.key $OLDPRIVATEDIR/$CERTNAME-$DATE.key"
    fi

    if [ -f $CAREQDIR/$CERTNAME.req ]; then
        echo "Déplacement de l'ancienne requête (""$ROSE""$CAREQDIR/$CERTNAME.req""$NORMAL"" vers ""$ROSE""$OLDREQDIR/$CERTNAME-$DATE.req""$NORMAL"") : "
        execute "mv -i $CAREQDIR/$CERTNAME.req $OLDREQDIR/$CERTNAME-$DATE.req"
    fi

    echo "Révocation du certificat ""$CYAN""$CERTNAME""$NORMAL"" terminée"
}

create() {
    check_certname $1

    echo "Création du certificat $CYAN""$CERTNAME""$NORMAL ..."

    if [ -f $CAPRIVATEDIR/$CERTNAME.key ]; then
        echo "$ROUGE""Il existe déjà une clé privée avec ce nom (option update ?) : $ROSE""$CAPRIVATEDIR/$CERTNAME.key"
        exit 1
    fi

    if [ -f $CAREQDIR/$CERTNAME.req ]; then
        echo "$ROUGE""Il existe déjà une requête avec ce nom (option update ?) : $ROSE""$CAREQDIR/$CERTNAME.req"
        exit 1
    fi

    if [ -f $SSLCERTDIR/$CERTNAME.pem ]; then
        echo "$ROUGE""Il existe déjà un certificat (option update ?) : $ROSE""$SSLCERTDIR/$CERTNAME.pem"
        exit 1
    fi

    echo "Création de la nouvelle clé privée (""$ROSE""$CAPRIVATEDIR/$CERTNAME.key""$NORMAL"") : "
    execute "openssl genrsa -aes256 -out $CAPRIVATEDIR/$CERTNAME.key 2048" || (echo "Erreur lors de la création de la clé privée" ; exit 1)

    echo "Création de la nouvelle requête (""$ROSE""$CAREQDIR/$CERTNAME.req""$NORMAL"") : "
    execute "openssl req -sha256 -new -key $CAPRIVATEDIR/$CERTNAME.key -out $CAREQDIR/$CERTNAME.req -config $CONFFILS" || (echo "Erreur lors de la création de la requête" ; exit 1)

    echo "Création du certificat et validation de celui-ci par le CA (""$ROSE""$SSLCERTDIR/$CERTNAME.pem""$NORMAL"" et copie du nouveau certificat dans ""$ROSE""$CACERTDIR/""$NORMAL"") : "
    execute "openssl ca -days 365 -in $CAREQDIR/$CERTNAME.req -out $SSLCERTDIR/$CERTNAME.pem -config $CONFFILS" || (echo "Erreur lors de la création du certificat à valider" ; exit 1)

    echo "Copie de la clé privée vers le dossier SSL (dans ""$ROSE""$SSLPRIVATEDIR/$CERTNAME.key""$NORMAL"") : "
    execute "cp -i $CAPRIVATEDIR/$CERTNAME.key $SSLPRIVATEDIR/$CERTNAME.key"

    echo "Génération du certificat ""$CYAN""$CERTNAME""$NORMAL"" terminée"
}

update() {
    check_certname $1

    echo "Mise à jour du certificat $CYAN""$CERTNAME""$NORMAL ..."

    revoke $CERTNAME

    create $CERTNAME

    echo "Mise à jour du certificat ""$CYAN""$CERTNAME""$NORMAL"" terminée"
}

help_display() {
    echo "Usage: $0 {-c|--create|-u|--update|-r|--revoke} CERTNAME"
    echo "Options :"
    echo "   -c | --create  : création d'un nouveau certificat (CERTNAME.pem) validé par le CA (CERTNAME ne doit pas déjà être utilisé)"
    echo ""
    echo "   -u | --update  : mise à jour du certificat CERTNAME.pem (re-validation par le CA)"
    echo ""
    echo "   -r | --revoke  : révocation du certificat CERTNAME.pem"
    echo ""
    echo "Copyright 2016 - Antoine CHABERT - chabert.antoine@gmail.com"
}

## Script

# Vérification que le script est bien lancé en root
if [ "$(id -u)" != "0" ]; then
   echo "$ROUGE""Ce script doit être lancé en root (avec les droits administrateurs)" 1>&2
   exit 1
fi

case "$1" in
    -r | --revoke)
        revoke $2
        ;;
    -u | --update)
        update $2
	    ;;
    -c | --create)
        create $2
        ;;
    *)
        help_display
        ;;
esac
