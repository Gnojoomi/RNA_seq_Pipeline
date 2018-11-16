#!/bin/bash -l
#SBATCH -D /home/path/to/main_directory
#SBATCH -J RNAseq Pipeline 

module load samtools 
module load bcftools
coordinates="$1"
genome="$2"
vcf="$3"


samtools faidx -r $1 $2 | bcftools consensus $3  

