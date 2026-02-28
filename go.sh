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

set -eu

trap 'pkill -P $$; exit' SIGINT SIGTERM

SIF_FILE=primus.sif

CONFIG="examples/torchtitan/configs/MI300X/deepseek_v3_16b-BF16-pretrain.yaml"
# CONFIG="examples/torchtitan/configs/MI300X/llama3.1_8B-BF16-pretrain.yaml"

export APPTAINERENV_HF_TOKEN=$HF_TOKEN
export APPTAINERENV_OMP_NUM_THREADS=32
export APPTAINERENV_TORCHINDUCTOR_COMPILE_THREADS=1

./power_server.py &
POWER_PID=$!

sleep 3 # wait for server to start

python -m chopper.profile.collect --gpu-telemetry --cpu-telemetry -- apptainer exec --writable-tmpfs --rocm --bind $PWD/aiter_build:/workspace/aiter/aiter/jit/build --bind $PWD:/workspace/Primus $SIF_FILE bash -c "cd /workspace/Primus && ./runner/primus-cli direct -- train pretrain --config $CONFIG"

kill $POWER_PID

wait $POWER_PID 2> /dev/null # idk if neccessary

# mv outputs deepseek_tuned_outputs
# mv outputs llama_tuned_outputs
# mkdir llama_tuned
# mv gpu.pkl cpu.pkl llama_tuned
# ./chopper.sh llama_tuned_outputs
# mv ts.pkl llama_tuned
# rm *.pkl
