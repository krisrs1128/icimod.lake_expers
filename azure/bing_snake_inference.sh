# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
export MPLCONFIGDIR=$(pwd)
export SKIMAGE_DATADIR=$(pwd)
eval "$(conda shell.bash hook)"
conda activate /anaconda/envs/lakes

# inference and evaluation on 2015 data
mkdir -p /datadrive/results/inference/bing_test-snake/
python icimod.glacial-lakes-baselines/inference_snake.py \
  --input_dir /datadrive/glaciers/bing_glaciers/processed/bing/images/ \
  --overwrite \
  --output_dir /datadrive/results/inference/bing_test-snake/ \
  --image_source bing

python icimod.glacial-lakes-baselines/evaluate.py \
  --inference_dir /datadrive/results/inference/sentinel_test-snake/ \
  --save_dir /datadrive/results/inference/sentinel_test-snake/ \
  --vector_label /datadrive/snake/lakes/GL_3basins_2015.shp \
  --dataset bing

  # inference and evaluation on all data
  mkdir -p /datadrive/results/inference/sentinel-snake/
  python icimod.glacial-lakes-baselines/inference_snake.py \
    --input_dir /datadrive/snake/lakes/sentinel//images/ \
    --output_dir /datadrive/results/inference/sentinel-snake/ \
    --overwrite \
    --image_source bing

  python icimod.glacial-lakes-baselines/evaluate.py \
    --inference_dir /datadrive/results/inference/sentinel-snake/ \
    --save_dir /datadrive/results/inference/sentinel-snake/ \
    --vector_label /datadrive/snake/lakes/GL_3basins_2015.shp \
    --dataset bing
