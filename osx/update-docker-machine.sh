#!/bin/bash

#brew install docker
#brew install docker-machine
#then run this script to replace the docker-machine binary with one that is compatible with parallels
#should not be an issue post docker machine 0.5

set -e 

wget -O /usr/local/bin/docker-machine "https://github.com/Parallels/docker-machine/releases/download/parallels%2F0.4.0-1/docker-machine_darwin-amd64" 
