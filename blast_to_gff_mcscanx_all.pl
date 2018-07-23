#! /usr/bin/perl -w

# blast_to_gff_mcscanx.pl
# take blast file (filtered and with metainfo) and print out a gff for mcscanx of all col-0 cnss and positions as well as unfiltered accession blast hits, I guess need some control to not keep printing out same CNSs
# Alan E. Yocca
# 04-0-18
# 07-02-18
# take blast m8 format and create .gff file for MCScanX using genomic hits
# can't find another way to do it then reformat the blast output into a gff format for mainly the creation of a dot plot
# but perhaps could do other things to
# simply treats every uniq blast hit as a gene, where it is in the parent genome
# that means final output will be like an interleaved gff between the reference and query species
# questions? aeyap42@gmail.com

use strict;
use Getopt::Std;

my $usage = "\n$0 -b <blast input> -o <output> \n\n";

our ($opt_b, $opt_o);
getopts('b:o:') or die "$usage";

if ( (!(defined $opt_b)) || (!(defined $opt_o)) ) {
  print "$usage";
  exit;
}

#if (-e $opt_o ) {
#print "File: $opt_o or exist, is it okay to overwrite it?\n"; 
#my $answer = <STDIN>;
#	if ($answer =~ /^y(?:es)?$/i) {
#		print "Excellent!\n";
#	}
#	else {
#		die "fine, I will not overwrite your files\n$0 not run :P\n\n";
#	}
#}

open (my $blast_fh, '<', $opt_b) || die "Cannot open the file $opt_b\n\n";
open (my $out_fh, '>', $opt_o) || die "Cannot open output: $opt_o\n\n";

my %seen_it;
my $written = 0;

#Blast M8 format example:
#Contig0 Chr1    99.49   26657   98      10      10473004        10499648        10463416        10490045        0.0     5.010e+04

# 1-QUERY_chromosome	2-REF_chromosome	3-Identity%	4-alignment_length	5-mismatches	6-gap_openings	7-QUERY_start	8-QUERY_end	9-REF_start	10-REF_end	11-E_value	12-Bit-score

while (my $line = <$blast_fh>) {
	chomp $line;
	my @info = split("\t",$line);
	my $ref_hit = $info[1] . "||" . $info[8] . "||" . $info[9];
	my $query_hit = $info[0] . "||" . $info[6] . "||" . $info[7];
	if ($seen_it{$ref_hit} && $seen_it{$query_hit}) {
		next;
	}
	elsif ($seen_it{$ref_hit}) {
		print $out_fh "$info[0]\t$query_hit\t$info[6]\t$info[7]\n";
		$written = $written + 1;
	}
	elsif ($seen_it{$query_hit}) {
		print $out_fh "$info[1]\t$ref_hit\t$info[8]\t$info[9]\n";
		$written = $written + 1;
	}
	else {
		print $out_fh "$info[0]\t$query_hit\t$info[6]\t$info[7]\n";
		print $out_fh "$info[1]\t$ref_hit\t$info[8]\t$info[9]\n";
		$written = $written + 2;
	}
	$seen_it{$ref_hit} = 1;
	$seen_it{$query_hit} = 1;
}

print "Written to $opt_o:	$written\n";

close $out_fh;
close $blast_fh;


exit;
