#!/bin/bash -l

#SBATCH -p debug
#SBATCH -N 8
#SBATCH -t 0:30:00
#SBATCH -J adi

cd $SLURM_SUBMIT_DIR

mkdir -p matrix
mkdir -p out
mkdir -p dump

mpirun -n 16 ./gem_main >& run.out
