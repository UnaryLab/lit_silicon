#!/usr/bin/env bash
#SBATCH --job-name=primus
#SBATCH --output=sbatch_primus_%j.out
##SBATCH --error=sbatch_primus_%j.err
#SBATCH -N 1
#SBATCH -t 4:00:00
#SBATCH -p mi2104x
#SBATCH --exclusive

set -eux

apptainer build --rocm -F primus.sif primus.def
