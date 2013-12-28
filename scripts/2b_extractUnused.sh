#!/bin/bash
picardDir=/users/mjzapata/programs/picard-tools-1.104/
samtoolsDir=/apps/pkg/samtools-0.1.18/rhel6_u2-x86_64/gnu/bin/
bamDir=/users/mjzapata/bamResults/
bamSortedDir=/users/mjzapata/bamResults/sorted/
unmappedDir=/users/mjzapata/bamResults/unmapped/
extractUnmappedReadsScriptDir=/users/mjzapata/scriptsextractunmapped/
mkdir ${extractUnmappedReadsScriptDir}
mkdir ${unmappedDir}
# hack near the bottom, selecting only the first 0:9 characters of the file basename
# difference between bamResults and Sorted??
mkdir ${unmappedDir}
i=0
while read line
do
bamFiles[ $i ]="$line"
(( i++ ))
done < <(find ${bamDir}*.bam -type f -exec basename {} \;)
arrayLength=${#bamFiles[@]}
echo arrayLength


for (( k=0; k < $arrayLength; k++))
do
echo $k
echo ${bamFiles[k]:0:9}
done



for (( num=0; num < $arrayLength; num++))
do
cat > ${extractUnmappedReadsScriptDir}pbsexctract_$i << EOF
#!/bin/bash
#PBS -q viper
#PBS -N mjzExtractUnmappedReads_${i}
#PBS -l walltime=5:01:00
#PBS -l nodes=1
${samtoolsDir}samtools view -b -f 8 ${bamDir}${bamFiles[num]} | java -jar ${picardDir}SamToFastq.jar I=/dev/stdin F=${unmappedDir}${bamFiles[num]}_1.fastq F2=${unmappedDir}${bamFiles[num]}_2.fastq
EOF
done



# output unmapped reads to paired