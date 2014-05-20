#!/bin/bash
#PBS -q viper
#PBS -N mjzTreeBuild
#PBS -l walltime=300:01:00
#PBS -l nodes=60
#*****bug clear the trimmed file first since it is being added to in a loop
. /users/mjzapata/scripts/wgaconfig.conf

##http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html

in_File=${mergedFADir}merged.fa
trimmed_File=${mergedFADir}merged_trimmed.fa

${javaCall} -jar ${programsDir}uniformSeqLength.jar $in_File $trimmed_File

${programsDir}FastTreeMP -fastest -nt -gtr $trimmed_File > ${mergedFADir}tree
#${programsDir}FastTreeMP -fastest -nt -gtr $in_File > ${mergedFADir}tree
# Problems,
#1.) sequences not the same length
#2.) Duplicate names
#3.) Not the same length due to N's not being added to the end of sequences (Can be fixed with program _____??);

