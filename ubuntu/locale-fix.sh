#!/bin/bash

#write to /etc/default/locale 
#changes only take effect after logout
sudo update-locale --reset LANG=en_US.UTF-8 LC_MESSAGES=POSIX LC_ALL=en_US.UTF-8

#generate locale files if required
sudo locale-gen en_US.*

#check that locale has been installed
locale -a | (grep -i en_US.utf8 > /dev/null) || { echo "Locale en_US.UTF-8 is not installed!"; exit 1; }


echo "All done, logout and log back in or reboot for the changes to take efffect!"
