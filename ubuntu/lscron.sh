#!/bin/bash
#List all cron jobs for all users

set -e 

for user in `cat /etc/passwd | cut -d":" -f1`;
do
  echo "Cron for $user"
  crontab -l -u $user 2>&1 | egrep -v "no crontab.*" | egrep -v "^#"
done
