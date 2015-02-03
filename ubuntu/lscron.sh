#!/bin/bash
#List all cron jobs for all users

set -e

for user in `cat /etc/passwd | cut -d":" -f1`;
do
  sudo crontab -l -u $user 2>&1 | egrep -v "no crontab.*"
done
