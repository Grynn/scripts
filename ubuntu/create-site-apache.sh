#!/bin/bash

set -o errexit -o nounset 

if [ $(id -u) -ne 0 ]; then
        echo "Script must be run as root!"
        exit -1
fi

if [ -z "${1:-}" ]; then 
	echo "Usage: `basename $0` site.com"
	exit -2
fi

if expr index "$1" \/ >/dev/null; then 
	echo "$1 is not an acceptable site name (contains invalid char /)" 1>&2 
	exit -3
fi

pathchk -p "${1}" || exit -1

#DEBIAN_FRONTEND=noninteractive apt-get update -q && apt-get install -q -y apache2 php5
a2enmod unique_id

addgroup --system web
usermod -G web www-data

#Create an example site
mkdir -p "/var/www/$1/logs"
chown git:web "/var/www/$1" -R
chmod u=rwx,g=rs,o=r "/var/www/$1"
chmod u=rwx,g=rws,o=r "/var/www/$1/logs"

#Create /etc/apache2/sites-available/sitename.conf (iff not exists)
if [ -f "/etc/apache2/sites-available/${1}.conf" ]; then 
	echo "Refusing to clobber '/etc/apache2/sites-available/${1}.conf'"
	exit;
fi

cat > "/etc/apache2/sites-available/${1}.conf" << EOF
<VirtualHost *:80>
	ServerName $1
	#ServerAlias *.$1
	DocumentRoot "/var/www/$1/app/web"

	#Try files, if nothing matches, fallback to /index.php
	FallbackResource /index.php

	#Logging	
	LogFormat "%{UNIQUE_ID}e %D %a %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" fcombined
	CustomLog "/var/www/$1/logs/access.log" fcombined
	ErrorLog "/var/www/$1/logs/error.log"
</VirtualHost>
EOF

a2ensite "${1}"
service apache2 restart
