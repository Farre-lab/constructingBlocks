#!/usr/bin/perl

use strict;
use warnings;
use FindBin qw($Bin);
use Cwd;
use Cwd 'abs_path';

# check the number of argument
if ($#ARGV+1 != 1) {
        print STDERR "Usage: ./constructHSBs.pl <parameter file>\n";
        exit(1);
}

my $params_f = $ARGV[0];

# parse parameter file
my %params = ();
open(F,"$params_f");
while(<F>) {
	chomp;
	my $line = trim($_);
        if ($line =~ /^#/ || $line eq "") { next; }
        my ($name, $value) = split(/=/);
        $name = trim($name);
        $value = trim($value);
        if (-f $value || -d $value) {
                $params{$name} = abs_path($value);
        } else {
                $params{$name} = $value;
        }
}
close(F);

check_parameters(\%params);

my $sf_dir = $params{"OUTPUTDIR"}."/SFs";
`mkdir -p $params{"OUTPUTDIR"}`;


# make blocks
print STDERR "\n## Constructing syntenic fragments ##\n"; 
my $cwd = getcwd();
`mkdir -p $sf_dir`;
`sed -e 's:<resolutionwillbechanged>:$params{"RESOLUTION"}:' $params{"CONFIGSFSFILE"} > $sf_dir/config.file`;
`sed -e 's:<needtobechanged>:$Bin/code/makeBlocks:' $params{"MAKESFSFILE"} > $sf_dir/Makefile`;

chdir($sf_dir);
`make all`;

print STDERR "Starting Perl script\n";
`perl $Bin/code/creatingBlocks.pl Building.Blocks $params{"REFSPC"}\_$params{"TARSPC"} $params{"RESOLUTION"}`;

chdir($cwd);
print STDERR "done\n";

###############################################################
sub check_parameters {
        my $rparams = shift;
        my $flag = 0;
        my $out = "";
        my @parnames = ("REFSPC","TARSPC","OUTPUTDIR","RESOLUTION","CONFIGSFSFILE","MAKESFSFILE");

        foreach my $pname (@parnames) {
                if (!defined($$rparams{$pname})) {
                        $out .= "$pname ";
                        $flag = 1;
                }
        }

        if ($flag == 1) {
                print STDERR "missing parameters: $out\n";
                exit(1);
        }
}

sub trim {
	my $str = shift;
        $str =~ s/^\s+//;
        $str =~ s/\s+$//;
        return $str;
}
