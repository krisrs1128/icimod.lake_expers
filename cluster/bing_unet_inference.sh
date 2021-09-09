# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
export MPLCONFIGDIR=$(pwd)
export SKIMAGE_DATADIR=$(pwd)
eval "$(conda shell.bash hook)"
conda activate /home/ksankaran/miniconda3/envs/lakes

# copy data over from staging
mkdir results data
cp /staging/ksankaran/lakes/labels/GL_3basins_2015* data/
cp /staging/ksankaran/lakes/bing_processed_data.tar.gz data/
cp /staging/ksankaran/lakes/MS_DeepLab_resnet_trained_VOC.pth .
cp /staging/ksankaran/lakes/trained_models/bing-unet_best.pth data/

# unzip data and models
tar -zxvf icimod.glacial-lakes-baselines.tar.gz
cd data
tar -zxvf bing_glaciers_processed.tar.gz
cd ..

# perform inference and evaluation on test set
python icimod.glacial-lakes-baselines/inference.py \
  --data_dir data/bing/splits/test \
  --x_dir images \
  --meta_dir meta \
  --stats_fn statistics.csv \
  --model_pth data/bing-unet_best.pth \
  --inference_dir results/bing_test-unet/

python icimod.glacial-lakes-baselines/evaluate.py \
  --inference_dir results/bing_test-unet \
  --save_dir results/bing_test-unet \
  --vector_label data/GL_3basins_2015.shp

# inference and evaluation overall
python icimod.glacial-lakes-baselines/inference.py \
  --data_dir data/bing/ \
  --x_dir images \
  --meta_dir meta \
  --stats_fn statistics.csv \
  --model_pth data/bing-unet_best.pth \
  --inference_dir results/bing-unet/

python icimod.glacial-lakes-baselines/evaluate.py \
  --inference_dir results/bing-unet \
  --save_dir results/bing-unet \
  --vector_label data/GL_3basins_2015.shp

rm icimod.glacial-lakes-baselines.tar.gz MS_DeepLab_resnet_trained_VOC.pth
tar -zcvf bing_unet_inference.tar.gz results/
