#!/usr/bin/perl

use Data::Dumper;
use strict;
use warnings;

open TMP, "<temp.txt";
my @lines = <TMP>;
close TMP;

do {
 $_ = shift @lines
 } while (!m/^Proto/ && @lines);

die unless @lines;

my @results;

foreach my $line ( @lines )
{
	my @flds = ( substr($line, 0,5), substr($line, 20,23), substr($line, 44, 23), substr($line, 80) );
	@flds = map  { s/^\s*//; s/\s*$//; $_} @flds;
	push @results, { 'proto'=>$flds[0], 'local'=>$flds[1], 'remote'=>$flds[2], 'app'=>$flds[3]};
}

#Etxract port into its own key
@results = map { 
			if ($_->{local} =~ m/^([\w\.\:]+):(\d+)$/) {
				$_->{port} = $2;
				$_->{local} = $1;	
			} else {
				$_->{port} = "0";
			}
			
			if ($_->{proto} =~ m/6/) {
				$_->{local} =~ s/^::$/\*/;
				$_->{remote} =~ s/^::(?=:)/\*/;
			} else {
				$_->{local} =~ s/^0\.0\.0\.0$/\*/;
				$_->{remote} =~ s/^0\.0\.0\.0(?=:)/\*/;
			}

			if ($_->{local} eq "*") { delete $_->{local} };
			if ($_->{remote} eq "*:*") { delete $_->{remote} };

			if ($_->{app} =~ m|^(\d+)/(.+)$|) {
				$_->{"app"} = $2;
				$_->{"app.pid"} = $1;
			}

			$_; 
		} @results;

#@results = sort { if ($a->{proto} eq $b->{proto}) {
#					return $a->{port} <=> $b->{port};
#					} else {
#			  	  	return $a->{proto} cmp $b->{proto}; } } @results;

@results = sort { $a->{port} <=> $b->{port} } @results;
                  
#Skip lines where local starts with 127.0.0.1: or (:::)
my @r1 = grep { (defined $_->{local}) ? $_->{"local"} !~ m/^(127\.0\.0\.1|:\:1)/ : 1 }  @results;

foreach (@r1) {
	#print proto, port, app (take slice from ref. to hash)
	print join(',', @{$_}{qw(proto port app)});
	
	my @keys = qw(local remote);
	my %flds;
	@flds{@keys} = @{$_}{@keys};

	if (grep {defined} values %flds) {
		my $count = 0;
		print " (";
		foreach my $k (@keys) {
			if (defined $flds{$k}) {
				print "," unless $count == 0;
				print "$k=>" . $flds{$k};
				++$count;
			}
		}
		print ")";
	};

	print "\n";
}

#repeat - but LOCAL only
my @r2 = grep { defined $_->{local} && $_->{"local"} =~ m/^(127\.0\.0\.1|:\:1)/ }  @results;
print "LOCAL only\n";
foreach (@r2) {
	#print proto, port, app (take slice from ref. to hash)
	print join(',', @{$_}{qw(proto port app)});
	
	my @keys = qw(local remote);
	my %flds;
	@flds{@keys} = @{$_}{@keys};

	if (grep {defined} values %flds) {
		my $count = 0;
		print " (";
		foreach my $k (@keys) {
			if (defined $flds{$k}) {
				print "," unless $count == 0;
				print "$k=>" . $flds{$k};
				++$count;
			}
		}
		print ")";
	};

	print "\n";
}

