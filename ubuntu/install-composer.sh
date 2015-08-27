#!/bin/bash

if [ $(id -u) -ne 0 ]; then
        echo "Script must be run as root!"
        exit -1
fi

curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

