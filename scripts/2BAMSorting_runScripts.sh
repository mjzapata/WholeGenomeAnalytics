#!/bin/bash
#PBS -q viper
#PBS -N mjzBT_runALL
#PBS -l walltime=0:15:00
#PBS -l nodes=20
. wgaconfig.conf

i=0
while read line
do
myScripts[ $i ]="$line"
(( i++ ))
done < <(find ${scripts2Dir}* -type f -exec basename {} \;)
arrayLength=${#myScripts[@]}
echo $arrayLength " files"

for(( i=0; i<$arrayLength; i++))
do
    qsub ${scripts2Dir}${myScripts[i]}
done
