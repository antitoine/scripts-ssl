#!/bin/sh
# Ce script permet de fixer les droits sur le site du wiki

OWNER=root # <-- owner
GROUP=www-data # <-- group
NOACCESS="bin/ inc/ conf/ data/ .htaccess"
ROOT="/var/www/wiki"

echo "Fix perms ..."

# Set general rules
chown -R $OWNER:$GROUP $ROOT
chmod -R 770 $ROOT

# Set specific rules
#for folder in $NOACCESS ; do
#    chmod -R 750 "$ROOT/$folder"
#done

echo "Done."
