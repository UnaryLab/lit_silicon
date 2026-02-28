#!/usr/bin/env bash
#SBATCH --job-name=primus
#SBATCH --output=sbatch_primus_%j.out
##SBATCH --error=sbatch_primus_%j.err
#SBATCH -N 1
#SBATCH -t 4:00:00
#SBATCH -p mi3008x
#SBATCH -q alloc_diwu_04012025_03312026
#SBATCH -w k002-003
#SBATCH --exclusive

set -eux

SLURM_SUBMIT_DIR=${PWD:-}
cd $SLURM_SUBMIT_DIR

apptainer build --rocm -F primus.sif primus.def
