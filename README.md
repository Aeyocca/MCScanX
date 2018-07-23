# MCScanX
My notes on how I use this great program

# Getting up and running



# Genomic dot-plot
MCScanX as a program searches for collinear blocks. It expects genic input and exports collinear blocks of genes
However, if the genomes you are comparing are not annotated, you may run into some issues

Therefore, I created some tips for how to search for collinear genomic regions rather than requiring annotated genomes

## Overview
My basic methodology is to:
<ul>
  <li>perform a genome vs. genome blast search<\li>
  <li>use a custom script "blast_to_mcscanx_gff.pl" to generate a GFF file with blast hits as the features rather than genes<\li>
  <li>Feed the blast output and GFF file to the MCScanX program, tweeking parameters slightly<\li>
  <li>Generate a dotplot<\li>
</ul>

## Genome vs. Genome Blast

For my research purposes, I perform a blast search between two different <i>Arabidopsis thaliana<\i> accessions

# README UNDER CONSTRUCTION, WILL GET BACK TO IT LATER
# IF YOU WANT IT FINISHED SOON, EMAIL ME: aeyap42@gmail.com

