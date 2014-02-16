#!/bin/bash
#PBS -q viper
#PBS -N mjzFastAtoMusc
#PBS -l walltime=0:6:00
#PBS -l nodes=60
. /users/mjzapata/scripts/wgaconfig.conf
mkdir ${mergedFADir}
#Find list of sorted FQ Files
i=0
while read line
do

    #ls -ltr $line | cut -c 32-33
    fqFiles[ $i ]="$line"

(( i++ ))
done < <(find ${snpCalledDir}*.fq)
echo $snpCalledDir${fqFiles[@]}

#run mpileup on sorted bamfiles
#${samtoolsDir}samtools mpileup -uf $refFile ${bamSortedFiles[@]} | ${samtoolsDir}bcftools view -bvcg - > ${bamSortedDir}var.raw.bcf

cat $snpCalledDir${fqFiles[@]} > ${mergedFADir}merged.fq
cat ${fqFiles[@]} > ${mergedFADir}merged.fq
echo ${mergedFADir}
${seqtkDir}seqtk seq -a ${mergedFADir}merged.fq 20 > ${mergedFADir}merged.fa

#users/mjzapata/programs/muscle3.8.31_i86linux64 -in ${mergedFADir}merged.fa -fastaout ${mergedFADir}muscleOutput.afa -clwout ${mergedFADir}clustalInput.aln -maxiters 1
${mafftDir}mafft-fftns --thread -1 --clustalout ${mergedFADir}merged.fa > ${mergedFADir}mafftOutput.afa
