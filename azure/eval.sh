#!/bin/bash
#
# Arg $1 = model name
# Arg $2 = dataset
# Usage:
#
# bash icimod.lake_expers/azure/eval.sh unet sentinel
# bash icimod.lake_expers/azure/eval.sh unet bing

# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
export MPLCONFIGDIR=$(pwd)
export SKIMAGE_DATADIR=$(pwd)
eval "$(conda shell.bash hook)"
conda activate /anaconda/envs/lakes

# evaluation overall
python icimod.glacial-lakes-baselines/evaluate.py \
  --save_dir /datadrive/results/inference/compressed/results/${2}-${1} \
  --eval_dir /datadrive/results/inference/compressed/results/${2}-${1} \
  --num_workers 20 \
  --vector_label /datadrive/snake/lakes/GL_3basins_2015.shp \
  --fname metrics_${2}_${1}.csv

# evaluation recent label
python icimod.glacial-lakes-baselines/evaluate.py \
  --save_dir /datadrive/results/inference/compressed/results/${2}-${1} \
  --eval_dir /datadrive/results/inference/compressed/results/${2}-${1} \
  --num_workers 20 \
  --vector_label /datadrive/snake/lakes/labeling/${2}/${2}_combined.shp \
  --fname metrics_${2}_${1}_recent.csv
