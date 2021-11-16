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

# perform evaluation on test and val sets
for split_type in test val; do
  python icimod.glacial-lakes-baselines/evaluate.py \
    --eval_paths /datadrive/results/inference/eval_paths/${2}_${split_type}-${1}.csv \
    --save_dir /datadrive/results/inference/compressed/results/${2}_${split_type}-${1} \
    --num_workers 5 \
    --vector_label /datadrive/snake/lakes/GL_3basins_2015.shp
done

# evaluation overall
python icimod.glacial-lakes-baselines/evaluate.py \
  --save_dir /datadrive/results/inference/compressed/results/${2}-${1} \
  --num_workers 5 \
  --eval_paths /datadrive/results/inference/eval_paths/${2}-${1}.csv \
  --vector_label /datadrive/snake/lakes/GL_3basins_2015.shp

# evaluation recent
python icimod.glacial-lakes-baselines/evaluate.py \
  --save_dir /datadrive/results/inference/compressed/results/${2}-${1} \
  --num_workers 5 \
  --eval_paths /datadrive/results/inference/eval_paths/${2}-${1}_recent.csv \
  --fname metrics_recent.csv \
  --vector_label /datadrive/snake/lakes/GL_3basins_2015.shp
