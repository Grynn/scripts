#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

if [ ! -f /etc/apt/sources.list.d/newrelic.list ]; then 
   echo deb http://apt.newrelic.com/debian/ newrelic non-free >> /etc/apt/sources.list.d/newrelic.list
   wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add -
fi
apt-get update && apt-get install newrelic-sysmond
