#!/usr/bin/perl -w
=head1 Info
    Script Author  : fuyuan, Yuan-SW-F, yuanswf@163.com
    Created Time   : 2022-12-31 16:11:48
    Example: abysw.wgdicol.pl
=cut
use strict;
use feature qw(say);
use Getopt::Long;
use asub;
my ($help);
GetOptions(
  "help!"=>\&USAGE,)
or USAGE();

open IN, shift; # lens
my %hash;
while (<IN>){
	/(\S+)\s+\S+\s+(\S+)/;
	$hash{$1} = $2;
}

open IN, shift; # col
my %col;
my @cols;
while (<IN>){
#	chomp;
	my @lines = split /\t/;
	push @cols, $lines[3] if ! exists $col{$lines[3]};
	$col{$lines[3]} .= $_;
}
mkdir "tmp";
for (@cols){
	output("tmp/$_.1", $col{$_});
}

my $c = shift; # .c.csv
open IN, $c;
open O, ">tmp/$c.2";
<IN>;
while (<IN>){
	chomp;
	s/\.0//g;
	my @line = split /,/;
	next if $line[9] < 0.2;
	say O join "\t", @line[1,3,4,2,5,6];
}
close IN;
close O;
`sortBed -i tmp/$c.2 > tmp/$c.2.s`;

for my $i (@cols){
	`bedtools intersect -a tmp/$c.2.s -b tmp/$i.1 | cut -f 4-6 | awk '{if (\$2>\$3){print \$1"\\t"\$3"\\t"\$2}else{print}}' > tmp/$i.2`;
	`sortBed -i tmp/$i.2 > tmp/$i.2s`;
	`mergeBed -i tmp/$i.2s -d 200 | awk -v OFS="\\t" '{\$4="$i"; print}'> tmp/$i.2s.bed`;
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
