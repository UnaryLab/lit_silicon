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

### Github

Clone the repository with submodules

```bash
git clone https://github.com/UnaryLab/Primus.git --recursive
cd Primus
```


## Install Dependencies

Set up a python virtual environment


```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
uv venv --python 3.12.0
.venv/bin/activate
```

Install chopper

```bash
uv pip install third_party/chopper
```

## Build Container for Pretraining

The account name will be provided once configured.

```bash
sbatch -q account_name build.sh
```

Please wait for the container to finish building.
You can monitor progress with `tail -f sbatch_primus_*.out`.

## Collect Pretraining traces

### Huggingface

Request access to [Llama 3.1 8B](https://huggingface.co/meta-llama/Llama-3.1-8B).
Make sure to export your huggingface key.

```bash
export HF_TOKEN=<key>
```

Submit all jobs together and wait for them to complete.

```bash
sbatch -q account_name go.sh llama_red
sbatch -q account_name go.sh deepseek_red
sbatch -q account_name go.sh llama_realloc
sbatch -q account_name go.sh llama_slosh
```

## Generate figures

```bash
sbatch -q account_name plot.sh
```

# TODO

- [ ] add GPU-Realloc vs GPU-Red vs CPU-Slosh
- [ ] add final power distribution
