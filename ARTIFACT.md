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

Submit both jobs and wait for completion.

```bash
sbatch -q account_name go.sh llama_red
sbatch -q account_name go.sh llama_realloc
sbatch -q account_name go.sh llama_slosh
sbatch -q account_name go.sh deepseek
```

## Generate figures

```bash
python -m chopper.plots.average_power_freq -g "['outputs/deepseek_red_profile_trace/gpu.pkl','outputs/llama_red_profile_trace/gpu.pkl']" -v "['deepseek','llama']" --starts "[0.1,0.1]" --stops "[0.95,0.95]" --ymaxs "[1.03,1.005]" --ymins "[1,.955]" -p True -f deepseek_llama_avg_pow_freq.png
python -m chopper.plots.lead_and_throughput -t "['outputs/deepseek_red_profile_trace/ts.pkl','outputs/llama_red_profile_trace/ts.pkl']" --frameworks "[2,2]" -v "['deepseek','llama']" --filename deepseek_llama_lead_and_throughput.png
python -m chopper.plots.freq_pow -g "['outputs/llama_red_profile_trace/gpu.pkl','outputs/llama_realloc_profile_trace/gpu.pkl','outputs/llama_slosh_profile_trace/gpu.pkl']" -v "['GPU-Red','GPU-Realloc','CPU-Slosh']" -a 0.6 --starts "[.2,.2,.2]" --stops "[1.0,1.0,1.0]" --metrics "['current_gfxclk','current_socket_power']" --metric_y_max "[1.11,1.005]" --metric_y_min "[1,0.935]"
```

# TODO

- [ ] add GPU-Realloc vs GPU-Red vs CPU-Slosh
- [ ] add final power distribution
