#!/usr/bin/perl -w
=head1 Info
    Script Author  : fuyuan, Yuan-SW-F, yuanswf@163.com
    Created Time   : 2023-02-11 17:31:15
    Example: abysw.select.class.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my ($help);
GetOptions(
  "help!"=>\&USAGE,)
or USAGE();

open IN, shift; #class.lst
my %c;
while (<IN>){
	$c{$1} = $2 if /(\S+)\s+(\S+)/;
}

open IN, shift; # of.tsv
my $head = <IN>;
chomp $head;
my @head = split /\t/, $head;
my %cc;
for (0..$#head){
	$cc{$_} = $c{$head[$_]} if exists $c{$head[$_]};
}
say $head;
while (<IN>){
	chomp;
	my @line = split /\t/;
	my %count;
	for (qw(A B C D E)){
		$count{$_} = 0;
	}
	for (sort {$a <=> $b} keys %cc){
		$count{$cc{$_}} += 1 if  $line[$_] > 0;
	}
	next if $count{"A"} > 0;
	next if $count{"B"} > 0;
	next if $count{"C"} > 0;
	next if $count{"D"} > 0;
#	next if $count{"E"} > 0;
	say $_ if $count{"E"} > 0;# && $count{"C"} > 0;
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
