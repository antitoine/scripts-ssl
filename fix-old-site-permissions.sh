#!/bin/sh
# Ce script permet de fixer les droits sur les sites plus maintenu
# Les droits en écriture sont tout simplement retiré pour éviter toute intrusion

OWNER=root # <-- owner
GROUP=www-data # <-- group
ROOTS="/var/www/old /var/www/ava /var/www/projetSI /var/www/projet2013"

for path in $ROOTS ; do
    # Set owner and group
    chown -R $OWNER:$GROUP $path
    # Set permissions
    chmod -R 750 $path
done
