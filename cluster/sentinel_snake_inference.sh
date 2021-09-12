# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
export MPLCONFIGDIR=$(pwd)
export SKIMAGE_DATADIR=$(pwd)
eval "$(conda shell.bash hook)"
conda activate /home/ksankaran/miniconda3/envs/lakes

# copy data over from staging
mkdir results data
mkdir results/sentinel_test-snake
mkdir results/sentinel-snake
cp /staging/ksankaran/lakes/labels/GL_3basins_2015* data/
cp /staging/ksankaran/lakes/sentinel.tar.gz data/

# unzip data and models
tar -zxvf icimod.glacial-lakes-baselines.tar.gz
cd data
tar -zxvf sentinel.tar.gz
cd ..

# inference and evaluation on 2015 data
python icimod.glacial-lakes-baselines/inference_snake.py \
  --gl_filename data/GL_3basins_2015.shp \
  --input_dir data/sentinel/splits/test/images/ \
  --output_dir results/sentinel_test-snake/ \
  --overwrite \
  --image_source sentinel \
  --verbose

python icimod.glacial-lakes-baselines/evaluate.py \
  --gl_filename data/GL_3basins_2015.shp \
  --inference_dir results/sentinel_test-snake \
  --save_dir results/sentinel_test-snake \
  --vector_label data/GL_3basins_2015.shp

# inference and evaluation overall
python icimod.glacial-lakes-baselines/inference_snake.py \
  --input_dir data/sentinel/images/ \
  --output_dir results/sentinel-snake/ \
  --overwrite \
  --image_source sentinel \
  --verbose

python icimod.glacial-lakes-baselines/evaluate.py \
  --inference_dir results/sentinel-snake \
  --save_dir results/sentinel-snake \
  --vector_label data/GL_3basins_2015.shp

rm icimod.glacial-lakes-baselines.tar.gz MS_DeepLab_resnet_trained_VOC.pth
tar -zcvf sentinel_snake_inference.tar.gz results/
