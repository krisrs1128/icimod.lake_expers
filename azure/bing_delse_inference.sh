# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
export MPLCONFIGDIR=$(pwd)
export SKIMAGE_DATADIR=$(pwd)
eval "$(conda shell.bash hook)"
conda activate /anaconda/envs/lakes

# perform inference and evaluation on test set
python icimod.glacial-lakes-baselines/inference.py \
  --model delse \
  --data_dir /datadrive/glaciers/bing_glaciers/processed/data/bing/splits/test \
  --x_dir images \
  --meta_dir meta \
  --stats_fn statistics.csv \
  --model_pth /datadrive/results/backup/bing-delse.pth \
  --inference_dir results/bing_test-delse/ \
  --divergence \
  --delse_pth /datadrive/snake/models/MS_DeepLab_resnet_trained_VOC.pth

python icimod.glacial-lakes-baselines/evaluate.py \
  --inference_dir /datadrive/results/inference/bing_test-delse \
  --save_dir /datadrive/results/inference/bing_test-delse \
  --vector_label /datadrive/snake/lakes/GL_3basins_2015.shp

# inference and evaluation overall
python icimod.glacial-lakes-baselines/inference.py \
  --model delse \
  --data_dir /datadrive/glaciers/bing_glaciers/processed/data/bing/ \
  --x_dir images \
  --meta_dir meta \
  --stats_fn statistics.csv \
  --model_pth /datadrive/results/backup/bing-delse.pth \
  --inference_dir /datadrive/results/inference/bing-delse/ \
  --divergence \
  --delse_pth /datadrive/snake/models/MS_DeepLab_resnet_trained_VOC.pth

python icimod.glacial-lakes-baselines/evaluate.py \
  --inference_dir /datadrive/results/inference/bing-delse \
  --save_dir /datadrive/results/inference/bing-delse \
  --vector_label /datadrive/snake/lakes/GL_3basins_2015.shp
