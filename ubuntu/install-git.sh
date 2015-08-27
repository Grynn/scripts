#!/bin/bash
#Install git and create a user 'git' that shares a group with www-data
#Part of preparing a fresh ubuntu installation for git deployable websites

set -o errexit; set -o nounset

if [ $(id -u) -ne 0 ]; then
        echo "Script must be run as root!"
        exit -1
fi

DEBIAN_FRONTEND=noninteractive apt-get update -q && apt-get install -q -y adduser git sudo

adduser --system git
chsh -s `which git-shell` git   #separate step, incase user git was already present in prev. step
addgroup --system web
usermod -G web git
usermod -G web www-data

#Fix git home directory permissions
chown git ~git
echo umask 027 > ~git/.profile
chown git ~git/.profile

#Create .ssh/authorized_keys and set perms
sudo -Hu git mkdir -p ~git/.ssh
chmod 700 ~git
chmod 700 ~git/.ssh

#Add pub key to git
if [ -f ~root/.ssh/authorized_keys ]; then
	cat ~root/.ssh/authorized_keys >> ~git/.ssh/authorized_keys
else
    touch ~git/.ssh/authorized_keys
	echo "Created blank authorized_keys file in ~git/.ssh; please add SSH public key"
fi
chown git:nogroup ~git/.ssh/authorized_keys
chmod 0600 ~git/.ssh/authorized_keys