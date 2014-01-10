#!/bin/bash
#PBS -q viper
#PBS -N mjzSNPCalling
#PBS -l walltime=50:01:00
#PBS -l nodes=1
. wgaconfig.conf

${bcftoolsDir}vcfutils.pl varFilter -Q 20 -d 20 /Users/malcolm/Documents/Cluster/snpCalls/ERR026015.bam.sorted.bam.var.raw.vcf | grep -v '^#' | wc -l

#$TACC_SAMTOOLS_DIR/bcftools/vcfutils.pl varFilter -Q 20 -d 20 /Users/malcolm/Documents/Cluster/snpCalls/ERR026015.bam.sorted.bam.var.raw.vcf | grep -v '^#' | wc -l

#grep -c "INDEL" ${vcfDir}${vcfFiles[i]}

#${samtoolsDir}bcftools/vcfutils.pl vcf2fq ${bamSortedDir}${bamSortedFiles[i]}

#view bcf file as vcf file

#${samtoolsDir}samtools view |
