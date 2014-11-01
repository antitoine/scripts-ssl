#!/bin/sh
# Permet de faire un backup d'un site (Données et Base de donnée)

PATH="/var/www/"
nb=1
for var in "$@"
do
    case "$var" in
        -n | --name)

            ;;
        -p | --path)
            PATH="$var"
            ;;
        *)
            echo "Usage: $0 {-n|--name} SITENAME [-p|--path PATH/TO/SITENAME/]"
            exit 0
            ;;
    esac
done
