#!/usr/bin/env perl
=head1 Info
    Script Author  : fuyuan, Yuan-SW-F, yuanswf@163.com
    Created Time   : 2022-06-27 15:46:40
    Example: intron.stat.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my ($help);
GetOptions(
  "help!"=>\&USAGE,)
or USAGE();

my %hash;
open IN,shift;
while (<IN>){
	my @line = split;
	if ($line[2] eq "CDS"){
		$line[8] =~ /Parent=([^\s\;]+)/;
		if (! exists $hash{$1}){
			$hash{$1} = $line[4];
		}else{
			say $line[3] - $hash{$1} +1;
			$hash{$1} = $line[4];
		}
	}
}
######################### Sub Routines #########################
sub USAGE{
my $uhead=`pod2text $0`;
my $usage=<<"USAGE";
USAGE:
	perl $0
	--help	output help information to screen
USAGE
print $uhead.$usage;
exit;}
