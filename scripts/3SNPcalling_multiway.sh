#!/bin/bash
#PBS -q viper
#PBS -N mjzSNPCalling
#PBS -l walltime=200:01:00
#PBS -l nodes=60
refFile=/projects/mjzapata/Salmonella_ref/salmonella_chrom_and_plas.fasta
bamSortedDir=/scratch/mjzapata/bamResults/sorted/
#GATKdir=/Users/malcolm/Documents/Cluster/Programs/GenomeAnalysisTK27/
samtoolsDir=/apps/pkg/samtools-0.1.18/rhel6_u2-x86_64/gnu/bin/
#Find list of sorted BAMFiles
i=0
while read line
do
bamSortedFiles[ $i ]="$line"
(( i++ ))
done < <(find ${bamSortedDir}*.bam)
echo $bamSortedDir${bamSortedFiles[@]}

#run mpileup on sorted bamfiles
${samtoolsDir}samtools mpileup -uf $refFile ${bamSortedFiles[@]} | ${samtoolsDir}bcftools view -bvcg - > ${bamSortedDir}var.raw.bcf


#java -Xmx1g -jar ${GATKdir}GenomeAnalysisTK.jar -T RealignerTargetCreator -R ${refFile} -I /data/snp_calling/RAL357_full_bwa.sorted.bam -o RAL357.realign.intervals -L 2L:100000-150000
