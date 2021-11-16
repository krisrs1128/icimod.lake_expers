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
tar -zxvf sentinel_delse-historical_trained.tar.gz
mv results/backup/*.pth ../data/
cd ..

# inference and evaluation on 2015 data
for split_type in test val; do
  python icimod.glacial-lakes-baselines/inference.py \
    --model delse \
    --data_dir data/sentinel/splits/${split_type} \
    --x_dir images \
    --meta_dir meta \
    --stats_fn statistics.csv \
    --model_pth data/sentinel-delse-historical_best.pth \
    --inference_dir results/sentinel_${split_type}-delse-historical/ \
    --dataset sentinel \
    --historical \
    --delse_pth MS_DeepLab_resnet_trained_VOC.pth
done

# inference overall
python icimod.glacial-lakes-baselines/inference.py \
  --model delse \
  --data_dir data/sentinel/ \
  --x_dir images \
  --meta_dir meta \
  --stats_fn statistics.csv \
  --model_pth data/sentinel-delse-historical_best.pth \
  --inference_dir results/sentinel-delse-historical/ \
  --dataset sentinel \
  --historical \
  --delse_pth MS_DeepLab_resnet_trained_VOC.pth

rm icimod.glacial-lakes-baselines.tar.gz MS_DeepLab_resnet_trained_VOC.pth
rm -rf data/
tar -zcvf sentinel_delse-historical_inference.tar.gz results/
