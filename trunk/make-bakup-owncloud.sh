#!/bin/sh
# Permet de faire un backup de owncloud 

DATE=$(date +"%Y%m%d%H%M")
NAME=owncloud
RESULTPATH=/home/backup/owncloud
SOURCEPATH=/var/www/owncloud
DBUSER=owncloud
DBNAME=owncloud
DBPSSWD=EeghequeiG7maiF6

mysqldump -u$DBUSER -p$DBPSSWD -r$RESULTPATH/backup_db_$NAME\_$DATE.sql $DBNAME
tar -zcvf $RESULTPATH/backup_dd_$NAME\_$DATE.tar.gz $SOURCEPATH
