# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
export MPLCONFIGDIR=$(pwd)
export SKIMAGE_DATADIR=$(pwd)
eval "$(conda shell.bash hook)"
conda activate /anaconda/envs/lakes

# perform inference and evaluation on test set
python icimod.glacial-lakes-baselines/inference.py \
  --data_dir /datadrive/glaciers/bing_glaciers/processed/data/bing/splits/test \
  --x_dir images \
  --meta_dir meta \
  --stats_fn statistics.csv \
  --model_pth /datadrive/results/backup/bing-unet_best.pth \
  --inference_dir results/bing_test-unet/

python icimod.glacial-lakes-baselines/evaluate.py \
  --inference_dir results/bing_test-unet \
  --save_dir results/bing_test-unet \
  --vector_label data/GL_3basins_2015.shp

# inference and evaluation overall
python icimod.glacial-lakes-baselines/inference.py \
  --data_dir /datadrive/glaciers/bing_glaciers/processed/data/bing/ \
  --x_dir images \
  --meta_dir meta \
  --stats_fn statistics.csv \
  --model_pth /datadrive/results/backup/bing-unet_best.pth \
  --inference_dir results/bing-unet/

python icimod.glacial-lakes-baselines/evaluate.py \
  --inference_dir results/bing-unet \
  --save_dir results/bing-unet \
  --vector_label data/GL_3basins_2015.shp
