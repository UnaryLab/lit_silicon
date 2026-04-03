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

MODEL="${1:-llama}"

if [[ "$1" == "llama" ]]; then
  CONFIG="examples/torchtitan/configs/MI300X/llama3.1_8B-BF16-pretrain.yaml"
else
  CONFIG="examples/torchtitan/configs/MI300X/deepseek_v3_16b-BF16-pretrain.yaml"
fi

export APPTAINERENV_HF_TOKEN=$HF_TOKEN
export APPTAINERENV_OMP_NUM_THREADS=32
export APPTAINERENV_TORCHINDUCTOR_COMPILE_THREADS=1

./power_server.py &
POWER_PID=$!

sleep 3 # wait for server to start

python -m chopper.profile.collect \
  --gpu-telemetry \
  --cpu-telemetry \
  --output-dir "${MODEL}_telemetry" \
  -- \
  apptainer exec \
  --writable-tmpfs \
  --rocm \
  --bind $PWD:/workspace/Primus \
  $SIF_FILE \
  bash -c "cd /workspace/Primus && ./runner/primus-cli direct -- train pretrain --config $CONFIG"

kill $POWER_PID
wait $POWER_PID || true 2> /dev/null # idk if neccessary

cd outputs/${MODEL}_profile_trace/
../../chopper.sh .
rm iteration_*.pkl
cp ../../${MODEL}_telemetry/*.pkl .
