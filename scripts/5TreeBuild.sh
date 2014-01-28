#!/bin/bash
#PBS -q viper
#PBS -N mjzFastAtoMusc
#PBS -l walltime=9:01:00
#PBS -l nodes=60
. wgaconfig.conf
mkdir ${mergedFADir}

${programsDir}FastTreeMP -fastest -nt -gtr ${mergedFADir}merged.fa > ${mergedFADir}tree

