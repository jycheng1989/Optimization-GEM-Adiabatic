#!/bin/bash -l

#SBATCH -A mp118
#SBATCH -q debug
#SBATCH -N 8
#SBATCH -t 0:30:00
#SBATCH -J adi

cd $SLURM_SUBMIT_DIR

mkdir -p matrix
mkdir -p out
mkdir -p dump

srun -n 192 ./gem_main >& run.out
