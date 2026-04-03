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

Submit both jobs and wait for completion.

```bash
sbatch -q account_name go.sh llama
sbatch -q account_name go.sh deepseek
```

## Generate figures

```bash
python -m chopper.plots.average_power_freq -g "['outputs/deepseek_profile_trace/gpu.pkl','outputs/llama_profile_trace/gpu.pkl']" -v "['deepseek','llama']" --starts "[0.1,0.1]" --stops "[0.95,0.95]" --ymaxs "[1.03,1.005]" --ymins "[1,.955]" -p True -f deepseek_llama_avg_pow_freq
```

# TODO

-[ ] add HF_TOKEN stuff
