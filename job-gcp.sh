#!/bin/bash -l

#SBATCH -p debug
#SBATCH -N 1
#SBATCH -t 0:30:00
#SBATCH -J adi

cd $SLURM_SUBMIT_DIR

mkdir -p matrix
mkdir -p out
mkdir -p dump

mpirun -n 2 ./gem_main >& run.out
