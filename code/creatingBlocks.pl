#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;
use FindBin qw($Bin);
use Cwd;
use Cwd 'abs_path';
require "$Bin/mergeBlocks.pm";

#Script to create blocks from Building.Blocks SFs

my $in = $ARGV[0];
my $out = $ARGV[1];
my $resolution = $ARGV[2];

open (IN, $in) or die "Can't open $in\n";

open (OUT, ">$out.EHall") or die "Can't create $out\n";

local $/ = "\>";
while  (<IN>) {
	my $line = $_;
	if ($line =~ /^>/) {next;}
	elsif ($line ne "") {
		my @tmp = split /\n/, $line;
		my ($ref,$chr, $start, $end) = $tmp[1] =~ /(\w+)\.(.*)\:(\d*)-(\d*)/;
		my ($tar,$chr1, $start1, $end1, $strand) = $tmp[2] =~ /(\w+)\.(\S+)\:(\d*)-(\d*)\s(\S)/;
		$strand = $strand.1;
		print OUT "$ref\,$chr\,$start\,$end\,$start1\,$end1\,$strand\,$tar\,$chr1\,$chr1\n";
	}
}

local $/ = "\n";
MergeBlocks::mergeBlocks("${out}.EHall", $resolution);




