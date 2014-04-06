#!/bin/sh
# Mail send if the system reboot

echo "The server 178.33.105.227 reboot : $(date)" | mail -s "[INFO] Server reboot" chabert.antoine@gmail.com

