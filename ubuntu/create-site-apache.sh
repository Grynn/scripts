#!/bin/bash
#Tested on trusty (14.04)
#Create a website in /etc/apache2/sites-available and activates it.
#Assumptions: 
#	Site has a front-controller at /var/www/sitename/$app/public/index.php
#   	Ex: Laravel uses $siteroot/public for the front-controller)
#	/var/www/sitename/$app is really a link to current version
#   	Ex: /var/www/sitename/$app/ => /var/www/sitename/v0.0.1/
#	(the above) should makes atomic deploys easy.
#Assumes site will be deployed via git (which requires that user git be allowed to write /var/www/sitename)
#and that user www-data should be allowed to read/execute but not write to /var/www/sitename

set -o errexit -o nounset 

if [ $(id -u) -ne 0 ]; then
        echo "Script must be run as root!"
        exit -1
fi

if [ $(lsb_release -c | cut -d $'\t' -f 2) != "trusty" ]; then 
	echo "Script has only been tested on Ubuntu Trusty Tahr";
	exit -1
fi

if [ -z "${1:-}" ]; then 
	echo "Usage: `basename $0` site.com"
	cat <<UsageMessage
Tested on trusty (14.04)
Create a website in /etc/apache2/sites-available and activates it.
Assumptions: 
	Site has a front-controller at /var/www/sitename/\$app/web/index.php
	/var/www/sitename/\$app is really a link to current version; example:
 	   /var/www/sitename/\$app/ => /var/www/sitename/v0.0.1/
	(the above) should makes atomic deploys easy.
Assumes site will be deployed via git (which requires that user git be allowed to write /var/www/sitename)
and that user www-data should be allowed to read/execute but not write to /var/www/sitename
UsageMessage
	exit -2
fi

if expr index "$1" \/ >/dev/null; then 
	echo "$1 is not an acceptable site name (contains invalid char /)" 1>&2 
	exit -3
fi

#pathchk -p "${1}" || exit -1

DEBIAN_FRONTEND=noninteractive apt-get update -q && apt-get install -q -y apache2 php5
a2enmod unique_id

addgroup --system web
usermod -G web www-data

#Create an example site
mkdir -p "/var/www/$1/logs"
chown git:web "/var/www/$1" -R
chmod u=rwx,g=rxs,o=r "/var/www/$1"
chmod u=rwx,g=rwxs,o=r "/var/www/$1/logs"

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
