#!/bin/bash -l

#SBATCH -p debug
#SBATCH -N 1
#SBATCH -t 0:30:00
#SBATCH -J adi

cd $SLURM_SUBMIT_DIR

mkdir -p matrix
mkdir -p out
mkdir -p dump

export PGI_ACC_TIME=1
#mpirun -n 2 pgprof -o gem.%p.prof ./gem_main >& run.out
mpirun -n 2 ./gem_main >& run.out
