# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
export MPLCONFIGDIR=$(pwd)
export SKIMAGE_DATADIR=$(pwd)
eval "$(conda shell.bash hook)"
conda activate /home/ksankaran/miniconda3/envs/lakes

# copy data over from staging
mkdir results data
cp /staging/ksankaran/lakes/labels/GL_3basins_2015* data/
cp /staging/ksankaran/lakes/sentinel.tar.gz data/
cp /staging/ksankaran/lakes/MS_DeepLab_resnet_trained_VOC.pth .

# unzip data and models
tar -zxvf icimod.glacial-lakes-baselines.tar.gz
cd data
tar -zxvf sentinel.tar.gz
cd ..

tar -zxvf trained_models.tar.gz
cd trained_models
tar -zxvf sentinel_delse_trained.tar.gz
mv results/backup/*.pth ../data/


# inference and evaluation on 2015 data
python icimod.glacial-lakes-baselines/inference.py \
  --model delse \
  --data_dir data/sentinel/splits/test \
  --x_dir images \
  --meta_dir meta \
  --stats_fn statistics.csv \
  --model_pth data/sentinel-delse_best.pth \
  --inference_dir results/sentinel_test-delse/ \
  --dataset sentinel \
  --delse_iterations 2 \
  --delse_pth MS_DeepLab_resnet_trained_VOC.pth

python icimod.glacial-lakes-baselines/evaluate.py \
  --inference_dir results/sentinel_test-delse \
  --save_dir results/sentinel_test-delse \
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
  --dataset sentinel \
  --delse_iterations 2 \
  --delse_pth MS_DeepLab_resnet_trained_VOC.pth

python icimod.glacial-lakes-baselines/evaluate.py \
  --inference_dir results/sentinel-delse \
  --save_dir results/sentinel-delse \
  --vector_label data/GL_3basins_2015.shp

rm icimod.glacial-lakes-baselines.tar.gz MS_DeepLab_resnet_trained_VOC.pth
rm -rf data/
tar -zcvf sentinel_delse_inference.tar.gz results/
