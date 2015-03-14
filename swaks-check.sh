#!/bin/sh
#Usage: chronic ./swaks-check.sh
#Required packages: moreutils swaks

set -e -x

which swaks > /dev/null || ( echo "swaks not installed or not in path!"; exit 1)
swaks --to "postmaster@domain.com" --from "test@FQDN.com"  #$? is non-zero if this fails

