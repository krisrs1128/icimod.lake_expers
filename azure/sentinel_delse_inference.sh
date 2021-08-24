# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
export MPLCONFIGDIR=$(pwd)
export SKIMAGE_DATADIR=$(pwd)
eval "$(conda shell.bash hook)"
conda activate /anaconda/envs/lakes

# inference and evaluation on 2015 data
python icimod.glacial-lakes-baselines/inference.py \
  --model delse \
  --data_dir /datadrive/snake/lakes/sentinel/splits/test \
  --x_dir images \
  --meta_dir meta \
  --stats_fn statistics.csv \
  --model_pth /datadrive/results/backup/sentinel-delse_best.pth \
  --inference_dir /datadrive/results/inference/sentinel_test-delse/ \
  --divergence \
  --dataset sentinel \
  --delse_pth /datadrive/snake/models/MS_DeepLab_resnet_trained_VOC.pth

python icimod.glacial-lakes-baselines/evaluate.py \
  --inference_dir /datadrive/results/inference/sentinel_test-delse/ \
  --save_dir /datadrive/results/inference/results/sentinel_test-delse \
  --vector_label data/GL_3basins_2015.shp

# inference and evaluation overall
python icimod.glacial-lakes-baselines/inference.py \
  --model delse \
  --data_dir data/sentinel/ \
  --x_dir images \
  --meta_dir meta \
  --stats_fn statistics.csv \
  --model_pth data/sentinel-delse_best.pth \
  --inference_dir results/sentinel-delse/ \
  --divergence \
  --dataset sentinel \
  --delse_pth /datadrive/snake/models/MS_DeepLab_resnet_trained_VOC.pth

python icimod.glacial-lakes-baselines/evaluate.py \
  --inference_dir /datadrive/results/inference/sentinel-delse \
  --save_dir /datadrive/results/inference/sentinel-delse \
  --vector_label data/GL_3basins_2015.shp
