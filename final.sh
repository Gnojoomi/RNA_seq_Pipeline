#!/bin/bash -l
#SBATCH -D /home/gnojoomi/Project_1/Final_RNAseq_pipeline
#SBATCH -J RNAseq Pipeline 
#SBATCH -o /home/gnojoomi/Project_1/Final_RNAseq_pipeline/str_out/index_%A_%a.out
#SBATCH -e /home/gnojoomi/Project_1/Final_RNAseq_pipeline/str_err/index_%A_%a.err
#SBATCH -t 12:00:00
#SBATCH --mem 60G

Files="/home/gnojoomi/Project_1/Final_RNAseq_pipeline/files"
Files_made="/home/gnojoomi/Project_1/Final_RNAseq_pipeline/files_made"
Scripts="/home/gnojoomi/Project_1/Final_RNAseq_pipeline/scripts"
VCF="/home/gnojoomi/Project_1/Final_RNAseq_pipeline/files/VCF"
dir_name=$1
name=$2
VCF_file=$3
gtf=$4

#########################################################
# Step 1: Making the transcript coordinates.
#
#########################################################

mkdir $Files_made/$dir_name
echo "Step 1: Making the transcript coordinates"
python $Scripts/final_master.py $Files/$gtf $Files_made/$dir_name/transcript_coordinates.intervals $Files_made/$dir_name/names_strand.txt
echo "Step 1: Done!"

#########################################################
# Step 2: Making the transcripts with changes.
#
#########################################################
module load vcftools 
module load bcftools 
echo "Step 2: Filter the VCF File takes 90 seconds"
vcftools --vcf $VCF/$dir_name/$VCF_file --out $VCF/$dir_name/VCF_pass --remove-filtered-all --recode --keep-INFO-all
echo "Step 2: Done with filtering"

echo "Step 2: bgzip VCF file"
bgzip $VCF/$dir_name/VCF_pass.recode.vcf
echo "Step 2: Done bgzip"


echo "Step 2: tabix VCF file"
tabix $VCF/$dir_name/VCF_pass.recode.vcf.gz
echo "Step 2: Done tabix"

echo "Step 2: Making the transcripts with changes allow for 7:30 minutes"
echo "$Files_made/$dir_name/"
bash $Scripts/final_master.sh $Files_made/$dir_name/transcript_coordinates.intervals $Files/Zea_mays.AGPv3.22.dna.genome.fa $VCF/$dir_name/VCF_pass.recode.vcf.gz > $Files_made/$dir_name/output.txt
echo "Step 2: Done!"

#########################################################
# Step 3: Getting rid of the spaces in between 
# then changing the names and concating same names. 
#########################################################

echo "Step 3: Getting rid of the spaces in between"
python $Scripts/final_sorting_test.py $Files_made/$dir_name/names_strand.txt $Files_made/$dir_name/output.txt $Files_made/$dir_name/output_names.txt $name $Files_made/$dir_name/transcripts.txt
echo "Step 3: Done!"

#########################################################
# Step 4: Reverse Complements.
#
#########################################################

echo "Step 4: Reverse Complements"
perl $Scripts/final_inverse.pl $Files_made/$dir_name/transcripts.txt $Files_made/$dir_name/final_transcripts.txt
echo "Step 4: Done!"

a="_B73_transcripts.fa"

#cat $Files_made/$dir_name/final_transcripts.txt $Files/B73_final_transcripts.fa > $name$a
#########################################################
