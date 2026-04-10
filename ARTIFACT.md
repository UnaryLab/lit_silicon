# Lit Silicon Artifact

## Setup

### GitHub

Clone the repository with submodules

```bash
git clone https://github.com/UnaryLab/Primus.git --recursive
cd Primus
```

Set up a python virtual environment

### Python Environment

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
uv venv --python 3.12.0
.venv/bin/activate
```

Install chopper

```bash
uv pip install third_party/chopper
```

### Huggingface

Request access to [Llama 3.1 8B](https://huggingface.co/meta-llama/Llama-3.1-8B).
Make sure to export your huggingface key.

```bash
export HF_TOKEN=<key>
```

## Run

This script will submit all jobs needed to build the container, collect the data, and plot figures.

```bash
./submit_all.sh account_name
```

## Validation

Once all jobs are completed, match the generated plots with their corresponding figures in the paper:

- Figure 16
  - a) deepseek_llama_straggler_per_gpu.png
  - b) deepseek_llama_lead_and_throughput.png
  - c) deepseek_llama_avg_pow_freq.png

- Figure 9
  - a) red_realloc_slosh_lead_and_throughput.png
  - b) red_realloc_slosh_freq_pow.png

## TODO

- [ ] add raw data
- [ ] add script for generating every figure, and its corresponding match in the paper
