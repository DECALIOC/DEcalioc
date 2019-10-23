#!/bin/bash
#PBS -q default
#PBS -j oe
#PBS -l nodes=1:ppn=0,walltime=00:00:00
#PBS -N DEM
#PBS -o ${PBS_JOBNAME}_output.txt

cd path

mpirun -np 0 ~/MYLIGGGHTS/src/lmp_auto < in.Lift100
