#!/usr/bin/perl -w
=head1 Info
    Script Author  : fuyuan, Yuan-SW-F, yuanswf@163.com
    Created Time   : 2023-03-22 16:25:28
    Example: abysw.draw.tree.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my ($help);
GetOptions(
  "help!"=>\&USAGE,)
or USAGE();

my $class = shift;
my $tree = shift;
open IN, $class;
my %hash;
while (<IN>){
	$hash{"$1$2"} = $3 if /(\w\w)[a-z]+\_(\w\w\w)[a-z]*\s+(\S+)/;
	say STDERR "$1$2\t$3";
}

$tree = `cat $tree`;
for (sort {$a cmp $b} keys %hash){
	$tree =~ s/$_/$hash{$_}__$_/g;
}
print $tree;
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
