#!/usr/bin/env bash

set -eu

./runner/primus-cli container --image rocm/primus:v26.1 --volume $PWD:/workspace/Primus -- train pretrain --config examples/torchtitan/configs/MI300X/llama3.1_8B-BF16-pretrain.yaml
# ./runner/primus-cli container --image rocm/primus:v26.1 --volume $PWD:/workspace/Primus -- train pretrain --config examples/torchtitan/configs/MI300X/deepseek_v3_16b-BF16-pretrain.yaml
