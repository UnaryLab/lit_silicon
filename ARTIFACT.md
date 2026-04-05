# Lit Silicon Artifact

## Download the Artifact

Choose either method to download the artifact.
Hotfixes will be applied to the github version, please use the updated README.

### Zendo

Copy the artifact to the hpcfund cluster.
The username will be provided once access has been configured for reviewers.

```bash
scp artifact.tar.gz username@hpcfund.amd.com:/work1/diwu/username
ssh username@hpcfund.amd.com
cd /work1/diwu/username
tar -xzvf artifact.tar.gz
cd artifact
```

### GitHub

Clone the repository with submodules

```bash
git clone https://github.com/UnaryLab/Primus.git --recursive
cd Primus
```

## Install Dependencies

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

Once all jobs are completed, compare the following images with figures in the paper:

- Figure 16
  a) deepseek_llama_straggler_per_gpu.png
  b) deepseek_llama_lead_and_throughput.png
  c) deepseek_llama_avg_pow_freq.png

- Figure 9
  a) red_realloc_slosh_lead_and_throughput.png
  b) red_realloc_slosh_freq_pow.png

## TODO

- [ ] add raw data
- [ ] add script for generating every figure, and its corresponding match in the paper
