#!/bin/bash

# Script to filter and annotate variants
# This script is for demonstration purposes only


# directories
ref="/workspace/supporting_files/hg38/hg38.fa"
results="/workspace/results"
funcotator_data="/workspace/funcotator_dataSources.v1.7.20200521g"


# -------------------
# Filter Variants - GATK4
# -------------------

# Filter SNPs
#gatk VariantFiltration \
#	-R ${ref} \
#	-V ${results}/raw_snps.vcf \
#	-O ${results}/filtered_snps.vcf \
#	-filter-name "QD_filter" -filter "QD < 2.0" \
#	-filter-name "FS_filter" -filter "FS > 60.0" \
#	-filter-name "MQ_filter" -filter "MQ < 40.0" \
#	-filter-name "SOR_filter" -filter "SOR > 4.0" \
#	-filter-name "MQRankSum_filter" -filter "MQRankSum < -12.5" \
#	-filter-name "ReadPosRankSum_filter" -filter "ReadPosRankSum < -8.0" \
#	-genotype-filter-expression "DP < 10" \
#	-genotype-filter-name "DP_filter" \
#	-genotype-filter-expression "GQ < 10" \
#	-genotype-filter-name "GQ_filter"
#
## Filter INDELS
#gatk VariantFiltration \
#	-R ${ref} \
#	-V ${results}/raw_indels.vcf \
#	-O ${results}/filtered_indels.vcf \
#	-filter-name "QD_filter" -filter "QD < 2.0" \
#	-filter-name "FS_filter" -filter "FS > 200.0" \
#	-filter-name "SOR_filter" -filter "SOR > 10.0" \
#	-genotype-filter-expression "DP < 10" \
#	-genotype-filter-name "DP_filter" \
#	-genotype-filter-expression "GQ < 10" \
#	-genotype-filter-name "GQ_filter"



#
##
## Select Variants that PASS filters
#gatk SelectVariants \
#	--exclude-filtered \
#	-V ${results}/filtered_snps.vcf \
#	-O ${results}/analysis-ready-snps.vcf
#
#
#gatk SelectVariants \
#	--exclude-filtered \
#	-V ${results}/filtered_indels.vcf \
#	-O ${results}/analysis-ready-indels.vcf


# -------------------
# Annotate Variants - Funcotator
# -------------------
./table_annovar.pl /workspace/snps.avinput humandb/ \
    -buildver hg38 \
    -out /workspace/annotated_snps \
    -protocol refGene,ensGene,avsnp150 \
    -operation g,g,f \
    -nastring . \
    -vcfinput

