#!/bin/bash
#PBS -q viper
#PBS -N mjzFastAtoMusc
#PBS -l walltime=0:150:00
#PBS -l nodes=60
. /Users/malcolm/Documents/github/WholeGenomeAnalytics/scripts/wgaconfig.conf
mkdir ${mergedFADir}
#Find list of sorted FQ Files
i=0
while read line
do
    fqFiles[ $i ]="$line"
(( i++ ))
done < <(find ${snpCalledDir}*.fq)



## CHANGE fasta names inside each file for each fasta file
# sed "1s/.*/$var/" ERR026015.bam.sorted.bam.fq > test.txt
while read line
do
    fqFileNames[ $i ]="$line"
(( i++ ))
done < <(find ${snpCalledDir}*.fq -type f -exec basename {} \;)
#echo ${fqFileNames[@]}

for i in "${fqFileNames[@]}"
do
#   x=${fqFileNames[i]}
    #echo ${x%%.*}
    #echo ${fqFileNames[$i]}
    var1='@'
    #var2=${fqFileNames[i]}
    var2=$i
    var=$var1$var2
    sed "1s/.*/$var/" ${fqFiles[i]} > ${fqFiles[i]}
done
########################################################


#run mpileup on sorted bamfiles
#${samtoolsDir}samtools mpileup -uf $refFile ${bamSortedFiles[@]} | ${samtoolsDir}bcftools view -bvcg - > ${bamSortedDir}var.raw.bcf

#cat $snpCalledDir${fqFiles[@]} > ${mergedFADir}merged.fq
cat ${fqFiles[@]} > ${mergedFADir}merged.fq
${seqtkDir}seqtk seq -a ${mergedFADir}merged.fq 20 > ${mergedFADir}merged.fa

#users/mjzapata/programs/muscle3.8.31_i86linux64 -in ${mergedFADir}merged.fa -fastaout ${mergedFADir}muscleOutput.afa -clwout ${mergedFADir}clustalInput.aln -maxiters 1

########${mafftDir}mafft-fftns --thread -1 --clustalout ${mergedFADir}merged.fa > ${mergedFADir}mafftOutput.afa
