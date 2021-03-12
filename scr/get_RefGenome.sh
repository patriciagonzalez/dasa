#!/usr/bin/bash 

#Script to download and extract reference genome file  

#Creating directories 
mkdir ../data/reference_genome 

# Download hg38 fasta file
wget http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz > ../data/reference_genome/hg38.fa.gz

#Extract file
gunzip hg38.fa.gz



