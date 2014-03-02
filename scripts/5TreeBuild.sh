#!/bin/bash
#PBS -q viper
#PBS -N mjzFastAtoMusc
#PBS -l walltime=300:01:00
#PBS -l nodes=60
#*****bug clear the trimmed file first since it is being added to in a loop
. /users/mjzapata/scripts/wgaconfig.conf
mkdir ${mergedFADir}
##http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html

in_File=${mergedFADir}merged.fa
trimmed_File=${mergedFADir}merged_trimmed.fa

############ make sure same length
i=0
while read line
do
    rows[$i]="$line"
    ((i++))
done < $in_File
arrayLength=${#rows[@]}
echo number of elements: $arrayLength


# Break the main text up into rows
for (( i=0; i < $arrayLength; i++))
do
    if [ "${rows[i]:0:1}" != ">" ]
then
    counts[i]=${#rows[$i]:0:1}
fi
done

# Find the smallest Value
SMALLEST=${counts[1]}
for i in ${counts[@]}; do
if [ $i -lt $SMALLEST ]; then
    SMALLEST=$i
fi
done
printf "%s\n" "Smallest number is $SMALLEST"

# Print the truncated rows
for (( i=0; i < $arrayLength; i++))
do
    if [ "${rows[i]:0:1}" != ">" ]
    then
        echo ${rows[$i]:0:$SMALLEST} >> $trimmed_File
    else
        echo ${rows[$i]} >> $trimmed_File
    fi
done
############ make sure same length


${programsDir}FastTreeMP -fastest -nt -gtr $trimmed_File > ${mergedFADir}tree

