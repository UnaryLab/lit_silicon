#!/usr/bin/env bash
#SBATCH --job-name=primus
#SBATCH --output=sbatch_primus_%j.out
##SBATCH --error=sbatch_primus_%j.err
#SBATCH -N 1
#SBATCH -t 4:00:00
#SBATCH -p mi2104x
#SBATCH --exclusive

set -eux

python -m chopper.plots.straggler_per_gpu -t "['outputs/deepseek_red_profile_trace/ts.pkl','outputs/llama_red_profile_trace/ts.pkl']" -v "['deepseek','llama']" --frameworks "[2,2]" --idx_start 44 --idx_end 47 -s .5 --y_maxs "[.025,.11]" --y_mins "[-.001,-.005]" --filename deepseek_llama_straggler_per_gpu.png
python -m chopper.plots.average_power_freq -g "['outputs/deepseek_red_profile_trace/gpu.pkl','outputs/llama_red_profile_trace/gpu.pkl']" -v "['deepseek','llama']" --starts "[0.1,0.1]" --stops "[0.95,0.95]" --ymaxs "[1.03,1.005]" --ymins "[1,.955]" -p True -f deepseek_llama_avg_pow_freq.png
python -m chopper.plots.lead_and_throughput -t "['outputs/deepseek_red_profile_trace/ts.pkl','outputs/llama_red_profile_trace/ts.pkl']" --frameworks "[2,2]" -v "['deepseek','llama']" --filename deepseek_llama_lead_and_throughput.png
python -m chopper.plots.freq_pow -g "['outputs/llama_red_profile_trace/gpu.pkl','outputs/llama_realloc_profile_trace/gpu.pkl','outputs/llama_slosh_profile_trace/gpu.pkl']" -v "['GPU-Red','GPU-Realloc','CPU-Slosh']" -a 0.3 --starts "[.05,.05,.05]" --stops "[1.0,1.0,1.0]" --metrics "['current_gfxclk','current_socket_power']" --metric_y_max "[1.11,1.005]" --metric_y_min "[1,0.935]" -p True -f red_realloc_slosh_freq_pow.png
python -m chopper.plots.lead_and_throughput -t "['outputs/llama_red_profile_trace/ts.pkl','outputs/llama_realloc_profile_trace/ts.pkl','outputs/llama_slosh_profile_trace/ts.pkl']" --frameworks "[2,2,2]" -v "['GPU-Red','GPU-Realloc','CPU-Slosh']" --filename red_realloc_slosh_lead_and_throughput.png
