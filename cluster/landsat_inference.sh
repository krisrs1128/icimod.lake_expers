# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
export MPLCONFIGDIR=$(pwd)
export SKIMAGE_DATADIR=$(pwd)
eval "$(conda shell.bash hook)"
conda activate /home/ksankaran/miniconda3/envs/lakes

# copy data over from staging
mkdir results data
cp /staging/ksankaran/lakes/labels/GL_3basins_2015* data/
cp /staging/ksankaran/lakes/le7-2015.tar.gz data/
cp /staging/ksankaran/lakes/unet-landsat7-2.tar.gz data/
cp /staging/ksankaran/lakes/MS_DeepLab_resnet_trained_VOC.pth .

# unzip data and models
tar -zxvf icimod.glacial-lakes-baselines.tar.gz
tar -zxvf data/le7-2015.tar.gz
tar -zxvf data/unet-landsat7-2.tar.gz

# perform inference
python icimod.glacial-lakes-baselines/inference.py \
  --data_dir data/le7-2015/splits/val \
  --x_dir images \
  --meta_dir meta \
  --stats_fn statistics.csv \
  --save_dir results/landsat_val-unet/ \
  --model_pth unet-landsat7-2/bing_test_best.pth \
  --inference_dir results/landsat_val-unet/ \
  --delse_pth MS_DeepLab_resnet_trained_VOC.pth

python icimod.glacial-lakes-baselines/evaluate.py \
  --inference_dir results/landsat_val-unet \
  --save_dir results/landsat_val-unet \
  --vector_label data/GL_3basins_2015.shp

rm icimod.glacial-lakes-baselines.tar.gz MS_DeepLab_resnet_trained_VOC.pth
tar -zcvf results.tar.gz results/
