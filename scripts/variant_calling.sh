#!/bin/bash

# Script to call germline variants in a human WGS paired end reads 2 X 100bp
# Following GATK4 best practices workflow - https://gatk.broadinstitute.org/hc/en-us/articles/360035535932-Germline-short-variant-discovery-SNPs-Indels-
# This script is for demonstration purposes only

if false
then
# download data
wget -p /Users/aravindhsudhakar/Desktop/BioInformatics/reads ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR813/SRR813420/SRR813420_1.fastq.gz
wget -p /Users/aravindhsudhakar/Desktop/BioInformatics/reads ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR813/SRR813420/SRR813420_2.fastq.gz
 
 echo "Run Prep files..."

################################################### Prep files (TO BE GENERATED ONLY ONCE) ##########################################################



# download reference files
wget -P ~/Desktop/BioInformatics/supporting_files/hg38/ https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz
gunzip ~/Desktop/BiInformatics/supporting_files/hg38/hg38.fa.gz

# index ref - .fai file before running haplotype caller
samtools faidx ~/Desktop/BioInformatics/supporting_files/hg38/hg38.fa


# ref dict - .dict file before running haplotype caller
gatk CreateSequenceDictionary R=~/Desktop/BioInformatics/supporting_files/hg38/hg38.fa O=~/Desktop/BioInformatics/supporting_files/hg38/hg38.dict


# download known sites files for BQSR from GATK resource bundle
wget -P ~/Desktop/BioInformatics/supporting_files/hg38/ https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf
wget -P ~/Desktop/BioInformatics/supporting_files/hg38/ https://storage.googleapis.com/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf.idx

fi
# directories
ref=/workspace/supporting_files/hg38/hg38.fa
known_sites="/workspace/supporting_files/hg38/Homo_sapiens_assembly38.dbsnp138.vcf"
aligned_reads="/workspace/aligned_reads"
reads="/Users/aravindhsudhakar/Desktop/BioInformatics/reads"
results="/workspace/results"
data="/workspace/data"

###################################################### VARIANT CALLING STEPS ###################################################################
# -------------------
# STEP 1: QC - Run fastqc 
# -------------------

echo "STEP 1: QC - Run fastqc"

#fastqc ${reads}/SRR813420_1.fastq.gz -o ${reads}/
#fastqc ${reads}/SRR813420_2.fastq.gz -o ${reads}/

# No trimming required, quality looks okay.


# --------------------------------------
# STEP 2: Map to reference using BWA-MEM
# --------------------------------------

echo "STEP 2: Map to reference using BWA-MEM"

# BWA index reference 
#bwa index ${ref}


#bwa mem -t 4 -R "@RG\tID:SRR813420\tPL:ILLUMINA\tSM:SRR813420" \ ${ref} \ ${reads}/SRR813420_1.fastq.gz ${reads}/SRR813420_2.fastq.gz > \ ${aligned_reads}/SRR813420.paired.sam

# -----------------------------------------
# STEP 3: Mark Duplicates and Sort - GATK4
# -----------------------------------------

echo "STEP 3: Mark Duplicates and Sort - GATK4"

#gatk MarkDuplicatesSpark -I ${aligned_reads}/SRR813420.paired.sam -O ${aligned_reads}/SRR813420_sorted_dedup_reads.bam


# ----------------------------------
# STEP 4: Base quality recalibration
# ----------------------------------


echo "STEP 4: Base quality recalibration"

# 1. Build the model
#gatk BaseRecalibrator \
#   -I ${aligned_reads}/SRR813420_sorted_dedup_reads.bam \
#   -R ${ref} \
#   --known-sites ${known_sites} \
#   -O ${data}/recal_data.table

# 2. Apply the model to adjust the base quality scores
#gatk ApplyBQSR \
#   -I ${aligned_reads}/SRR813420_sorted_dedup_reads.bam \
#   -R ${ref} \
#   --bqsr-recal-file ${data}/recal_data.table \
#   -O ${aligned_reads}/SRR813420_sorted_dedup_bqsr_reads.bam

# -----------------------------------------------
# STEP 5: Collect Alignment & Insert Size Metrics
# -----------------------------------------------


echo "STEP 5: Collect Alignment & Insert Size Metrics"

# Collect alignment summary metrics
#gatk CollectAlignmentSummaryMetrics \
#   R=${ref} \
#   I=${aligned_reads}/SRR813420_sorted_dedup_bqsr_reads.bam \
#   O=${aligned_reads}/alignment_metrics.txt
#
## Collect insert size metrics and generate histogram
#gatk CollectInsertSizeMetrics \
#   INPUT=${aligned_reads}/SRR813420_sorted_dedup_bqsr_reads.bam \
#   OUTPUT=${aligned_reads}/insert_size_metrics.txt \
#   HISTOGRAM_FILE=${aligned_reads}/insert_size_histogram.pdf


# ----------------------------------------------
# STEP 6: Call Variants - gatk haplotype caller
# ----------------------------------------------

echo "STEP 6: Call Variants - gatk haplotype caller"

#gatk HaplotypeCaller -R ${ref} -I ${aligned_reads}/SRR813420_sorted_dedup_bqsr_reads.bam -O ${results}/raw_variants.vcf

# extract SNPs & INDELS

gatk SelectVariants -R ${ref} -V ${results}/raw_variants.vcf --select-type SNP -O ${results}/raw_snps.vcf
gatk SelectVariants -R ${ref} -V ${results}/raw_variants.vcf --select-type INDEL -O ${results}/raw_indels.vcf