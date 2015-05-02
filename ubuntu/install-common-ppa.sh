#!/bin/bash
#
#Install generally useful PPAs
#
#Author: Vishal Doshi <vishal.doshi@gmail.com>
#License: Do what you want, would be nice if you gave me attrbution though (http://vishaldoshi.me)
#

set -e -o nounset

####
# working locale is needed for apt-add-repository
echo "1. Setting locale to en_US.UTF-8"

locale-gen en_US.UTF-8 		> /dev/null
dpkg-reconfigure locales	> /dev/null
update-locale LANG=en_US.UTF-8	> /dev/null

export LANG=en_US.UTF-8
DEBIAN_FRONTEND=noninteractive 

apt-get install -q -y software-properties-common python-software-properties > /dev/null

echo "2. Installing generally useful PPAs (nginx, redis, node, php5.6, git)"
apt-add-repository ppa:nginx/stable -y
apt-add-repository ppa:rwky/redis -y
apt-add-repository ppa:chris-lea/node.js -y
apt-add-repository ppa:ondrej/php5-5.6 -y
add-apt-repository ppa:git-core/ppa -y
