#!/bin/sh
# Put the web server in maintenance mode

APACHEDIR="/etc/apache2/"
APACHEEXE="/etc/init.d/apache2"
TMPFILE="/home/script/tmp.maintenance"
APACHEMAINPAGE="maintenance"

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

case "$1" in
    start)
        if [ -e $TMPFILE ]; then
           echo "The tmp file already exist, the script has been run, launch it with stop or remove the tmp file ( $TMPFILE )" 1>&2
           exit 1
        fi
        echo "Disable current web site and save them in the tmp file :"
        cd $APACHEDIR"sites-enabled/"
        for site in *; do
            echo $site >> $TMPFILE
            a2dissite $site
        done
        echo "Enable maintenance page :"
        a2ensite $APACHEMAINPAGE
        echo "Restart Apache :"
        $APACHEEXE restart
        echo "Done."
        ;;
    stop)
        echo "Enable web sites saved :"
        while read site; do
            a2ensite $site
        done < $TMPFILE
        echo "Disable maintenance page :"
        a2dissite $APACHEMAINPAGE
        echo "Restart Apache :"
        $APACHEEXE restart
        echo "Remove tmp file :"
        rm $TMPFILE
        echo "Done."
        ;;
    status)
        if [ -e $TMPFILE ]; then
            echo "This script has been launch."
        else
            echo "No file tmp, the scrit has not been launch."
        fi
        exit 0
        ;;
    *)
        echo "Usage: $0 {start|stop|status}"
        ;;
esac
