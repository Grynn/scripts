ping $(perl -e '$ENV{"SSH_CLIENT"} =~ m/^(\S+)/; print "$1\n";')
