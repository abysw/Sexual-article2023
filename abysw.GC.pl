#!/usr/bin/perl -w
=head1 Info
    Script Author  : fuyuan, Yuan-SW-F, yuanswf@163.com
    Created Time   : 2023-02-16 14:28:02
    Example: abysw.GC.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
my ($help);
GetOptions(
  "help!"=>\&USAGE,)
or USAGE();

my $file = shift;
my $gc = shift;
$gc ||= "G";
$gc = uc($gc);
my $rgc = $gc;
$rgc =~ tr/[ATCG]/[TAGC]/;
$rgc = reverse($rgc);

my $new = ("_" x length($gc));
open IN, $file;
open O1,">$file.$gc.fas";
open O, ">$file.$gc";
while (<IN>){
	my $id = $1 if />?(\S+)/;
	$/ = ">";
	my $seq = <IN>;
	$/ = "\n";
	$seq =~ s/\s+//g;
	$seq =~ s/$gc/$new/g;
	$seq =~ s/$rgc/$new/g;
	print `abysw green statistics chrosomese $id masked by $gc`;
	my @line = split //, $seq;
	print O1 "$id\n$seq\n";
	for (0..$#line){
		if ($line[$_] eq "_"){
			say O "$id\t$_\t" . ($_+1);
		}
	}
}
close O;
`mergeBed -i $file.$gc > $file.$gc.bed && rm $file.$gc`;

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
