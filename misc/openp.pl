#!/usr/bin/perl

#Script to show open ports tcp & udp
#Will not show port forwards etc.
#Should also dump iptables output
#finally nmap ourselves to double check

use strict;

my $tmp = `netstat -tulnp`;
my @lines = split "\n", $tmp;
foreach my $line ( @lines )
{
    my @flds = split /\s+/,$line;
    my $c = 0;
    my $app = $flds[0] =~ /^udp/ ? $flds[5] : $flds[6];
    my $tabs = $flds[0] =~ /6$/ ? "\t\t" : "\t";
    print join("\t", @flds[0,3]) . "$tabs$app\n"  if ($flds[3] =~ /0\.0\.0\.0:/ || $flds[3] =~ /:::/);
}

print "Please run \niptables\nnmap -sT -p1-65535 127.0.0.1 ::1\n for extra thoroughness\n";
