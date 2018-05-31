# Optimization-GEM-Adiabatic

For compilation on GCP, first set environment variables for the PGI compiler and Open MPI library:
```
module load pgi/18.4 openmpi/2.1.2/pgi/18.4
```

`Make` must be executed first in dfftpack library source code subdirectory 'code/dfftpack' and then in the main source code subdirectory 'code', producing the executable 'gem_main'.

The example input file 'gem.in' in the repository root directory is a simple test case. Copy it to a separate directory, e.g. '~/test', where you want output files to be generated. Run 'gem_main' from this directory using the 'mpirun' wrapper, with appropriate calls to Slurm for job allocation. The number of mpi processes must match KMX * NTUBE in 'gem.in', i.e. 16 for the example file. For example:
```
salloc -N 2 -t 00:20:00
mpirun -n 16 ~/Optimization-GEM-Adiabatic/code/gem_main
```
Noting that one node has 8 vCPUs, so the MPI is 16.
