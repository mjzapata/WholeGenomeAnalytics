#!/bin/bash
#PBS -q viper
#PBS -N mjzSNPCalling
#PBS -l walltime=10:01:00
#PBS -l nodes=1
. wgaconfig.conf
mkdir ${scripts3Dir}
mkdir ${snpCalledDir}
#Feature: add in feature to send a message if file size ends up being 0 bytes
#Find list of sorted BAMFiles
i=0
while read line
do
bamSortedFiles[ $i ]="$line"
(( i++ ))
done < <(find ${bamSortedDir}*.bam -type f -exec basename {} \;)
echo ${bamSortedFiles[@]}

arrayLength=${#bamSortedFiles[@]}
# SORT BAMFILES and store in directory "sorted"
for ((i=0; i < arrayLength; i++))
do
cat > ${scripts3Dir}pbsSNPcall_$i << EOF
#!/bin/bash
#PBS -q viper
#PBS -N mjzSNPCalling_$i
#PBS -l walltime=15:01:00
#PBS -l nodes=1
${samtoolsDir}samtools mpileup -uf $refFile ${bamSortedDir}${bamSortedFiles[i]} | ${bcftoolsDir}bcftools view -cg - | perl ${bcftoolsDir}vcfutils.pl vcf2fq > ${snpCalledDir}${bamSortedFiles[i]}.fq
EOF
done

#${samtoolsDir}samtools mpileup -uf $refFile ${bamSortedDir}${bamSortedFiles[i]} | ${samtoolsDir}bcftools view -bvcg - > ${snpCalledDir}${bamSortedFiles[i]}.var.raw.bcf

#java -Xmx1g -jar ${GATKdir}GenomeAnalysisTK.jar -T RealignerTargetCreator -R ${refFile} -I /data/snp_calling/RAL357_full_bwa.sorted.bam -o RAL357.realign.intervals -L 2L:100000-150000
#/Users/malcolm/Documents/Cluster/bamResults/sorted/ERR026015.bam.sorted