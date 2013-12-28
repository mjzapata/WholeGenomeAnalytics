#!/bin/bash
bamDir=/users/mjzapata/bamResults/
bamSortedDir=/scratch/mjzapata/bamResults/sorted/
samtoolsDir=/apps/pkg/samtools-0.1.18/rhel6_u2-x86_64/gnu/bin/
sortScriptDir=/users/mjzapata/sortscripts/
#Bug1: recreate directory or test to see if it exists?
#Bug2: I don't really understand that regular expression next to outputName
mkdir ${bamSortedDir}
i=0
while read line
do
    bamFiles[ $i ]="$line"
    (( i++ ))
done < <(find ${bamDir}*.bam -type f -exec basename {} \;)
echo ${bamFiles[@]}



arrayLength=${#bamFiles[@]}
# SORT BAMFILES and store in directory "sorted"
for ((i=0; i < arrayLength; i++))
do
cat > ${sortScriptDir}pbssort_$i << EOF
#!/bin/bash
#PBS -q viper
#PBS -N mjzBTRefGenes_subset_${i}
#PBS -l walltime=5:01:00
#PBS -l nodes=1
${samtoolsDir}samtools sort $bamDir${bamFiles[i]} $bamSortedDir${bamFiles[i]}.sorted
EOF
done


#cat > ${sortScriptDir}pbssort_$i << EOF
#outputName=${bamFiles[i]%.*}
#samtools sort $bamDir${bamFiles[i]} $bamSortedDir${outputName}.sorted
