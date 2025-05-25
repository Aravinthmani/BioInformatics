# Whole Exome Sequencing (WES) Pipeline Project

This repository contains the source code and documentation for a Whole Exome Sequencing (WES) analysis pipeline. The pipeline performs alignment, variant calling, filtering, and annotation of short variants (SNPs and INDELs) using tools like BWA, GATK, and Funcotator.

## 📄 Project Report

You can find the detailed project report in the [BioinfromaticsReport.pdf](./BioinfromaticsReport.pdf) file.


## 🧬 Pipeline Overview

1. **Input**: Raw FASTQ files
2. **Reference Genome**: hg38
3. **Alignment**: BWA-MEM
4. **Post-processing**: Sorting, MarkDuplicates (Picard)
5. **Variant Calling**: GATK HaplotypeCaller
6. **Variant Filtering**: GATK VariantFiltration
7. **Annotation**: GATK Funcotator

## ⚙️ Tools and Technologies

- BWA
- GATK (v4+)
- SAMtools
- Picard
- Funcotator
- Docker

