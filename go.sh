#!/usr/bin/env bash

set -eu

# sudo amd-smi reset -G

CONFIG="examples/torchtitan/configs/MI300X/deepseek_v3_16b-BF16-pretrain.yaml"
# CONFIG="examples/torchtitan/configs/MI300X/llama3.1_8B-BF16-pretrain.yaml"

python -m chopper.profile.collect --gpu-telemetry --cpu-telemetry -- ./runner/primus-cli container --image rocm/primus:v26.1 --volume $PWD:/workspace/Primus -- train pretrain --config "$CONFIG"
