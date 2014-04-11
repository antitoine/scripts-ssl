#!/bin/bash
# Monitoring juste de ping sur les sites

# les hotes a tester
HOSTS="178.33.41.240"

# sujets des mails
SUBJECT="[ KO ] Ping Monitoring - Machine Down - Server"
SUBJECT_UP="[ OK ] Ping Monitoring - Machine Up - Server"

# envoyer un SMS via tm4b.com
#EMAILID="moi@domain.tld"
#TELID="XXXXX"
#PASSWD="XXXXX"

# envoyer un mail
EMAILSIMPLE="chabert.antoine@gmail.com"

# nombre test
COUNT=4

# log
LOG="/var/log/ping_monitoring.log"

echo "----- BEGIN Ping test at $(date) -----" >> $LOG

for myHost in $HOSTS
do
    if ! ping -q -c $COUNT $myHost >> $LOG
    # elle est KO
    then
        if [ ! -f /tmp/mail.$myHost ]
        # on n est pas encore au courant
        then
            if [ -f /tmp/ping.$myHost ]
                # elle etait KO cinq minutes avant, faut prevenir
            then
                # envoyer un SMS
                #echo "To - $TELID\nFrom - $TELID\nMessage - La machine $myHost ne repond plus a $(date)\nPassword - $PASSWD" | mail -s "[$myHost] $SUBJECT" $EMAILID
                # envoyer un mail normal
                echo "La machine $myHost ne repond plus a $(date)" | mail -s "[$myHost] $SUBJECT" $EMAILSIMPLE
                #  creer le fichier pour indiquer que le mail a ete envoye
                touch /tmp/mail.$myHost
            fi
            touch /tmp/ping.$myHost
        fi
    else
        # elle n est pas KO
        if [ -f /tmp/ping.$myHost ]
        then
            rm /tmp/ping.$myHost
        fi
        if [ -f /tmp/mail.$myHost ]
        then
            rm /tmp/mail.$myHost
            # renvoyer un mail
            echo "La machine $myHost repond a nouveau a $(date)" | mail -s "[$myHost] $SUBJECT_UP" $EMAILSIMPLE
        fi
    fi
done

echo "----- END Ping test at $(date) -----" >> $LOG
