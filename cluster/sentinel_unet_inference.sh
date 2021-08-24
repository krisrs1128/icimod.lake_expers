# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
export MPLCONFIGDIR=$(pwd)
export SKIMAGE_DATADIR=$(pwd)
eval "$(conda shell.bash hook)"
conda activate /home/ksankaran/miniconda3/envs/lakes

# copy data over from staging
mkdir results data
cp /staging/ksankaran/lakes/labels/GL_3basins_2015* data/
cp /staging/ksankaran/lakes/sentinel-2015.tar.gz data/
cp /staging/ksankaran/lakes/MS_DeepLab_resnet_trained_VOC.pth .
cp /staging/wtian24/lakes/trained_models/sentinel-unet_best.pth data/

# unzip data and models
tar -zxvf icimod.glacial-lakes-baselines.tar.gz
cd dat
tar -zxvf sentinel.tar.gz
cd ..

# inference and evaluation on 2015 data
python icimod.glacial-lakes-baselines/inference.py \
  --data_dir data/sentinel/splits/test \
  --x_dir images \
  --meta_dir meta \
  --stats_fn statistics.csv \
  --model_pth data/sentinel-unet_best.pth \
  --inference_dir results/sentinel_val-unet/ \
  --dataset sentinel

python icimod.glacial-lakes-baselines/evaluate.py \
  --inference_dir results/sentinel_test-unet \
  --save_dir results/sentinel_test-unet \
  --vector_label data/GL_3basins_2015.shp

# inference and evaluation overall
python icimod.glacial-lakes-baselines/inference.py \
  --data_dir data/sentinel/ \
  --x_dir images \
  --meta_dir meta \
  --stats_fn statistics.csv \
  --model_pth data/sentinel-unet_best.pth \
  --inference_dir results/sentinel-unet/ \
  --dataset sentinel

python icimod.glacial-lakes-baselines/evaluate.py \
  --inference_dir results/sentinel-unet \
  --save_dir results/sentinel-unet \
  --vector_label data/GL_3basins_2015.shp

rm icimod.glacial-lakes-baselines.tar.gz MS_DeepLab_resnet_trained_VOC.pth
tar -zcvf sentinel_unet_inference.tar.gz results/
