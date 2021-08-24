# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
export MPLCONFIGDIR=$(pwd)
export SKIMAGE_DATADIR=$(pwd)
eval "$(conda shell.bash hook)"
conda activate /anaconda/envs/lakes

# inference and evaluation on 2015 data
python icimod.glacial-lakes-baselines/inference.py \
  --data_dir /datadrive/snake/lakes/sentinel/splits/test \
  --x_dir images \
  --meta_dir meta \
  --stats_fn statistics.csv \
  --model_pth /datadrive/results/backup/sentinel-unet_best.pth \
  --inference_dir /datadrive/results/inference/sentinel_test-delse/ \
  --divergence \
  --dataset sentinel

python icimod.glacial-lakes-baselines/evaluate.py \
  --inference_dir /datadrive/results/inference/sentinel_test-unet/ \
  --save_dir /datadrive/results/inference/results/sentinel_test-unet \
  --vector_label data/GL_3basins_2015.shp

# inference and evaluation overall
python icimod.glacial-lakes-baselines/inference.py \
  --data_dir data/sentinel/ \
  --x_dir images \
  --meta_dir meta \
  --stats_fn statistics.csv \
  --model_pth data/sentinel-unet.pth \
  --inference_dir results/sentinel-unet/ \
  --divergence \
  --dataset sentinel

python icimod.glacial-lakes-baselines/evaluate.py \
  --inference_dir /datadrive/results/inference/sentinel-unet \
  --save_dir /datadrive/results/inference/sentinel-unet \
  --vector_label data/GL_3basins_2015.shp
