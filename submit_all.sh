#!/usr/bin/env bash
#
# Submit all artifact jobs with proper dependencies
# Usage: ./submit_all.sh [account_name]
#
# Jobs are submitted in order:
#   1. build.sh - Build the container
#   2. go.sh (x4) - Run training jobs (parallel, depend on build)
#   3. plot.sh - Generate figures (depends on all training jobs)

set -eu

ACCOUNT="${1:-}"

if [[ -z "$ACCOUNT" ]]; then
    echo "Usage: $0 <account_name>"
    exit 1
fi

echo "Submitting jobs with account: $ACCOUNT"

# Submit build job
BUILD_JOB=$(sbatch --parsable -q "$ACCOUNT" build.sh)
echo "Submitted build.sh as job $BUILD_JOB"

# Submit training jobs (depend on build, can run in parallel with each other)
LLAMA_RED_JOB=$(sbatch --parsable -q "$ACCOUNT" --dependency=afterok:$BUILD_JOB go.sh llama_red)
echo "Submitted go.sh llama_red as job $LLAMA_RED_JOB (depends on $BUILD_JOB)"

DEEPSEEK_RED_JOB=$(sbatch --parsable -q "$ACCOUNT" --dependency=afterok:$BUILD_JOB go.sh deepseek_red)
echo "Submitted go.sh deepseek_red as job $DEEPSEEK_RED_JOB (depends on $BUILD_JOB)"

LLAMA_REALLOC_JOB=$(sbatch --parsable -q "$ACCOUNT" --dependency=afterok:$BUILD_JOB go.sh llama_realloc)
echo "Submitted go.sh llama_realloc as job $LLAMA_REALLOC_JOB (depends on $BUILD_JOB)"

LLAMA_SLOSH_JOB=$(sbatch --parsable -q "$ACCOUNT" --dependency=afterok:$BUILD_JOB go.sh llama_slosh)
echo "Submitted go.sh llama_slosh as job $LLAMA_SLOSH_JOB (depends on $BUILD_JOB)"

# Submit plot job (depends on all training jobs)
PLOT_JOB=$(sbatch --parsable -q "$ACCOUNT" --dependency=afterok:$LLAMA_RED_JOB:$DEEPSEEK_RED_JOB:$LLAMA_REALLOC_JOB:$LLAMA_SLOSH_JOB plot.sh)
echo "Submitted plot.sh as job $PLOT_JOB (depends on all training jobs)"

echo ""
echo "All jobs submitted. Summary:"
echo "  Build:          $BUILD_JOB"
echo "  Llama Red:      $LLAMA_RED_JOB"
echo "  DeepSeek Red:   $DEEPSEEK_RED_JOB"
echo "  Llama Realloc:  $LLAMA_REALLOC_JOB"
echo "  Llama Slosh:    $LLAMA_SLOSH_JOB"
echo "  Plot:           $PLOT_JOB"
echo ""
echo "Monitor with: squeue -u \$USER"

