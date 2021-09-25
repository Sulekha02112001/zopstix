#!/bin/bash
source ./var.sh

if [[ $STATUS=active ]]
then
   echo Service is running
else
    curl -sfL https://get.k3s.io | sh -
    for x in $(ls kubernetes/*.yml); do
	    kubectl apply -f $x
    done
fi

crontab -l | { cat; echo "0 4 * * * 3 root /usr/bin/apt update -q -y >> /var/log/apt/automaticupdates.log"; } | crontab -

crontab -l | { cat; echo "0 4 * * * 3 root /usr/bin/apt upgrade -q -y >> /var/log/apt/automaticupdates.log"; } | crontab -

if [[ $STATUS=active ]]
then
    for x in $(ls kubernetes/*.yml); do
	    kubectl apply -f $x
    done
fi

