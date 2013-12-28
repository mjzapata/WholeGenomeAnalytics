#!/bin/bash
#PBS -q viper
#PBS -N mjzSNPCalling
#PBS -l walltime=10:01:00
#PBS -l nodes=1
refFile=/projects/mjzapata/Salmonella_ref/salmonella_chrom_and_plas.fasta
bamSortedDir=/scratch/mjzapata/bamResults/sorted/
snpCalledDir=/scratch/mjzapata/snpCalls/
#GATKdir=/Users/malcolm/Documents/Cluster/Programs/GenomeAnalysisTK27/
samtoolsDir=/apps/pkg/samtools-0.1.18/rhel6_u2-x86_64/gnu/bin/
SNPScriptDir=/users/mjzapata/snpscripts/
mkdir ${SNPScriptDir}
mkdir ${snpCalledDir}
#Feature: add in feature to send a message if file size ends up being 0 bytes
#Find list of sorted BAMFiles
i=0
while read line
do
bamSortedFiles[ $i ]="$line"
(( i++ ))
done < <(find ${bamSortedDir}*.bam -type f -exec basename {} \;)
echo {bamSortedFiles[@]}

arrayLength=${#bamSortedFiles[@]}
# SORT BAMFILES and store in directory "sorted"
for ((i=0; i < arrayLength; i++))
do
cat > ${SNPScriptDir}pbsSNPcall_$i << EOF
#!/bin/bash
#PBS -q viper
#PBS -N mjzSNPCalling_$i
#PBS -l walltime=200:01:00
#PBS -l nodes=1
${samtoolsDir}samtools mpileup -uf $refFile ${bamSortedDir}${bamSortedFiles[i]} | ${samtoolsDir}bcftools view -bvcg - > ${snpCalledDir}${bamSortedFiles[i]}.var.raw.bcf
EOF
done

#java -Xmx1g -jar ${GATKdir}GenomeAnalysisTK.jar -T RealignerTargetCreator -R ${refFile} -I /data/snp_calling/RAL357_full_bwa.sorted.bam -o RAL357.realign.intervals -L 2L:100000-150000
