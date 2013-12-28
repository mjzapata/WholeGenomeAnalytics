#!/bin/bash
#PBS -q viper
#PBS -N mjzBT_runALL
#PBS -l walltime=0:15:00
#PBS -l nodes=1
scriptDir=/users/mjzapata/snpscripts/
i=0
while read line
do
myScripts[ $i ]="$line"
(( i++ ))
done < <(find ${scriptDir}* -type f -exec basename {} \;)
arrayLength=${#myScripts[@]}
echo $arrayLength " files"

for(( i=0; i<$arrayLength; i++))
do
qsub ${scriptDir}${myScripts[i]}
done