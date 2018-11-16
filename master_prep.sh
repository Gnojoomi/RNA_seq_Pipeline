#!/bin/bash -l
#SBATCH -D /home/path/to/main_directory
#SBATCH -J RNAseq Pipeline 

###########################################################################
# Arguments and Paths  
###########################################################################
####################### 55 SECONDS TO RUN WHOLE SCRIPT ####################
Files=/home/path/to/main_directory/RNAseq_pipeline/files
Files_made=/home/path/to/main_directory/RNAseq_pipeline/files_made
Scripts=/home/path/to/main_directory/RNAseq_pipeline/scripts

genome=$1
gff3=$2
version=$3

###############################################################################
# Step 1: Indexing genome and building a dictionary
###############################################################################
module load picardtools
module load java
module load samtools/1.2
module load R maven java GATK
module load vcftools
module load bedtools
module load cufflinks

dict=".dict"
COPY=".COPY.gff3"
formatted="formatted."
final="final."
gtf=".gtf"
zea_mays="Zea_mays."

echo "Step 1: Indexing the Genome"
srun samtools faidx  $Files/$genome

echo "Step 1: Creating Dictionary for Genome"
srun java -jar /share/apps/picard-tools-2.7.1/picard.jar CreateSequenceDictionary REFERENCE= $Files/$genome OUTPUT= $Files/$genome$dict
module load cufflinks

##################################################
# Step 2: Getting rid of anything except exons. 
#         converting GFF3 to GTF.
##################################################


echo "Step 2: GFF prep"
cp $Files/$gff3 $Files/$gff3$COPY

echo "Step 2: GFF get exons only"
grep -E 'exon' $Files/$gff3$COPY > $Files/$formatted$gff3
sed 's/Parent=transcript:/Parent=/' $Files/$formatted$gff3 > $Files/$final$gff3

echo "Step 2: Making GTF file"
gffread $Files/$final$gff3 -T -o $Files/$zea_mays$version$gtf
rm $Files/$formatted$gff3
rm $Files/$final$gff3
rm $Files/$gff3$COPY

### I commented this out because this part makes a bed file to filter the VCF file for only transcripts Adds extra minutes for no reason.###

#cut -f1,4,5 $Files/Zea_mays.AGPv3.22.gtf > $Files/VCF_interval1.bed
#sort -k 1,1 -k2,2n $Files/VCF_interval1.bed > $Files/VCF_interval.bed
#bedtools merge -i $Files/VCF_interval.bed > $Files/VCF_final.bed
#echo "track name='vcf intervals' description='bed ordered'" > $Files/header.txt
#cat $Files/header.txt $Files/VCF_final.bed > $Files/VCF_intervals.bed
#rm $Files/header.txt
#rm $Files/VCF_interval1.bed
#rm $Files/VCF_interval.bed
#rm $Files/VCF_final.bed

##################################################
# Step 3: B73 transcripts 
##################################################
echo "Step 3: Making B73 transcripts"
B73="B73_transcripts"
fa=".fa"
gffread -w $Files/$B73$version$fa -g $Files/$genome $Files/$zea_mays$version$gtf
