#!/bin/bash
#
# Jump to a mounted/running container's filesystem, but without chroot
# this means that tools like vim etc, which are installed on the container host
# are available and can be used to examine/modify the container's filesystem
# 
# docker exec / nsenter chroot to the docker container. So for example, vim would have
# to be installed in the container, probably not what we want.
# 
# since we cannot change directory from within a bash script
# we could write this script as a bash function that is put
# in ~/.bashrc

# or use this as cd `docker-fs short-id`

set -e

if [ -z $1 ]; then
        echo Usage: docker-fs [short-id \| name]
        exit 1;
fi

ID=$(docker inspect -f '{{.Id}}' $1)
echo "/var/lib/docker/aufs/mnt/$ID"