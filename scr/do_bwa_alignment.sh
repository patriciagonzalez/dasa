#!/usr/bin/bash 

#Script to perfome the alingment with reference genome using BWA MEM 

#Creating directories 

mkdir ../data/aligned_files ../data/intermediate_files 
mkdir ../data/intermediate_files/QC

echo "Starting the quality control with fast QC"
#Run fastqc for each file 
echo "file L001_R1"
fastqc ../data/original_files/12878_S19_L001_R1_001.fastq.gz 
echo "file L001_R2"
fastqc ../data/original_files/12878_S19_L001_R2_001.fastq.gz
echo "file L002_R1"
fastqc ../data/original_files/12878_S19_L002_R1_001.fastq.gz 
echo "file L002_R2"
fastqc ../data/original_files/12878_S19_L002_R2_001.fastq.gz

#moving fastqc files to folder QC in intermediate_files directory
echo "Moving QC files"
find ../data/original_files/ -type f -exec grep -qiF 'fastqc' {} \; -exec mv {} ../data/intermediate_files/QC/ \;

echo "Concatenating R1 files"
#Concatenate the R1 files
cat ../data/original_files/12878_S19_L001_R1_001.fastq.gz  ../data/original_files/12878_S19_L002_R1_001.fastq.gz > ../data/intermediate_files/R1_12878_S19.fq.gz

echo "Concatenating R2 files"
#Concatenate the R2 files 
cat  ../data/original_files/12878_S19_L001_R2_001.fastq.gz  ../data/original_files/12878_S19_L002_R2_001.fastq.gz > ../data/intermediate_files/R2_12878_S19.fq.gz


echo "Creating reference genome hg38 index"
#Create reference index
bwa index -p hg38bwaidx -a bwtsw ../data/reference_genome/hg38.fa  
# -p index name (change this to whatever you want) 
# -a index algorithm (bwtsw for long genomes)

echo "Starting alignment"
#Generate the alignment 
bwa mem -t 8  hg38bwaidx ../data/intermediate_files/R1_12878_S19.fq.gz ../data/intermediate_files/R2_12878_S19.fq.gz  > ../data/intermediate_files/R1_R2_12878_S19.sam


#Check out the alignment
echo cat ../data/intermediate_files/R1_R2_12878_S19.sam
#less - ls ../data/intermediate_files/R1_R2_12878_S19.sam

echo "Converting .sam to .bam file"
#Convert .sam to .bam
samtools view -h -b -f 4 -S ../data/intermediate_files/R1_R2_12878_S19.sam > ../data/aligned_files/R1_R2_12878_S19.bam
#-h include header 
#-b option of samtools for outputting in BAM format
#-f Only output alignments with all bits set in INT present in the FLAG field.
# -S Ignored for compatibility with previous samtools versions. 


#See the file 
#samtools view -H  ../data/aligned_files/R1_R2_12878_S19.bam

echo "Sort bam file"
#Sort the .bam file
samtools sort  ../data/aligned_files/R1_R2_12878_S19.bam  >  ../data/aligned_files/R1_R2_12878_S19_sorted.bam

echo "Generating .bam.bai file"
#Generate .bai file 
samtools index ../data/aligned_files/R1_R2_12878_S19_sorted.bam  ../data/aligned_files/R1_R2_12878_S19_sorted.bam.bai


#View file comparing with the reference genome
#samtools tview ../data/aligned_files/R1_R2_12878_S19_sorted.bam ../data/reference_genome/hg39.fas


 


