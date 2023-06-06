#!/usr/bin/perl -w
=head1 Info
    Script Author  : sunwenjing, Yuan-SW-F, yuanswf@163.com
    Created Time   : 2022-10-31 08:40:53
    Example: perl.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my ($help);
GetOptions(
  "help!"=>\&USAGE,)
or USAGE();

say join "\t", qw(sampleA sampleB baseMeanA       baseMeanB       baseMean        log2FoldChange  lfcSE   stat pvalue  padj);
open IN, shift;
my %hash;
while (<IN>){
	chomp;
	say join "\t", $_, qw(BLO_S1  BLO_S4  12.0076372448888        1538.84117285907        775.424405051978        -6.85698965188211       0.181248387891927       -37.8320035374368       0       0);
	$hash{$_} = 1;
}

open IN, shift;
while (<IN>){
	if (/>(\S+)/){
		say join "\t", $1, qw(BLO_S1  BLO_S4 0 0  0 0 0  0  0 0) if ! exists $hash{$1};
	}
}
close;
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
