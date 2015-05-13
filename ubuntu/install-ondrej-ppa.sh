#!/bin/bash

set -e -o nounset 

apt-get install -y software-properties-common python-software-properties
add-apt-repository ppa:ondrej/php5-5.6
