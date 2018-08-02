#! /usr/bin/perl -w

# blast_cns_add_metainfo.pl
# take in CNS vs col-0 blast file and CNS file, spit out fasta with CNS headers formatted for CoGe
#********************WILL NOT GIVE STRAND INFO******************** not really sure how critical that is here, can CoGe do it? if so then the info has to be in the blast output somewhere, ignore for now
# Alan E. Yocca
# 03-27-18
# 07-11-18
# blast_add_metainfo.pl
# edit to do genomic hits instead of CNSs
# goal is to do this then convert to gff for mcscanx
# I think I would have to get non-overlapping hits or something... for now treat every
# while we are at it, make the gff file
# rename it, blast_to_mcscanx.pl


use strict;
use Getopt::Std;

my $usage = "\n$0 -b <blast> -o <adjusted blast output> -g <gff file for mcscanx> \n\n";

our ($opt_b, $opt_g, $opt_o);
getopts('b:o:g:') or die "$usage";

if ( (!(defined $opt_b)) || (!(defined $opt_o)) || (!(defined $opt_g)) ) {
  print "$usage";
  exit;
}

open (my $blast_fh, '<', $opt_b) || die "Cannot open the blast file: $opt_b\n\n";
open (my $gff_fh, '>', $opt_g) || die "Cannot open the gff output file: $opt_g\n\n";
open (my $out_fh, '>', $opt_o) || die "Cannot open the blast output: $opt_o\n\n";


#1||3760||5630||AT1G01010.1||1||CDS||306206330||1
#5||26435630||26435652||33952_AT5G66130||+||CNS||1||62411

##actually, should just load cns into hash, then loop through blast
#my %cns;
#my $loop_control = 0;
#my $cns;
#my $non_chrom_hit = 0;

#while (my $line = <$cns_fh>) {
#	chomp $line;
#	if ($loop_control) {
#		$cns{$cns} = $line;
#		$loop_control = 0;
#	}
#	else {
#		$loop_control = 1;
#		my @cns = split(">",$line);
#		$cns = $cns[1];
#	}
#}

#master plan here:
#just change ref / query chrom names
#make the gff too because we are here anyway right?
#since doing this, need hash so don't repeat 'genes'
#i doubt i will see any but rule that out for reasons this isn't going to work

my %seen_gene;
my $damn_saw_it_ref = 0;
my $damn_saw_it_query = 0;

while (my $line = <$blast_fh>) {
	chomp $line;
	my @line = split("\t",$line);
	my $new_ref = $line[1] . "_" . $line[8] . "_" . $line[9];
	my $new_query = $line[0] . "_" . $line[6] . "_" . $line[7];
	print $out_fh "$new_ref\t";
	print $out_fh "$new_query\t";
	if ( $seen_gene{$new_ref} ) {
		$damn_saw_it_ref = $damn_saw_it_ref + 1;
	}
	else {
		print $gff_fh "$line[1]\t$new_ref\t$line[8]\t$line[9]\n";
	}
        if ( $seen_gene{$new_query} ) {
                $damn_saw_it_query = $damn_saw_it_query + 1;
        }
        else {
                print $gff_fh "$line[0]\t$new_query\t$line[6]\t$line[7]\n";
        }
	for (my $i = 2; $i < @line; $i++) {
		print $out_fh "$line[$i]\t";
	}
	print $out_fh "\n";
	$seen_gene{$new_ref} = 1;
	$seen_gene{$new_query} = 1;
}

print "Any ref left out of gff?: $damn_saw_it_ref\n";
print "Any query left out of gff?: $damn_saw_it_query\n";

close $out_fh;
#close $cns_fh;
close $blast_fh;

exit;


