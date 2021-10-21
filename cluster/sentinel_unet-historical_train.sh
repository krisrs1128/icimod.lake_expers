# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
export MPLCONFIGDIR=$(pwd)
export SKIMAGE_DATADIR=$(pwd)
eval "$(conda shell.bash hook)"
conda activate /home/ksankaran/miniconda3/envs/lakes

# copy data over from staging
cp /staging/ksankaran/lakes/sentinel.tar.gz .
cp /staging/ksankaran/lakes/MS_DeepLab_resnet_trained_VOC.pth .

# unzip transferred data
mkdir results data
tar -zxvf sentinel.tar.gz
mv sentinel data/
tar -zxvf icimod.glacial-lakes-baselines.tar.gz

# clear unzipped data
rm sentinel.tar.gz
rm icimod.glacial-lakes-baselines.tar.gz

# start training
CUDA_LAUNCH_BLOCKING=1 python icimod.glacial-lakes-baselines/train.py \
  --experiment_name sentinel-historical-unet \
  --data_dir data/ \
  --dataset sentinel \
  --delse_pth MS_DeepLab_resnet_trained_VOC.pth \
  --save_dir results/save \
  --backup_dir results/backup \
  --log_dir results/logs \
  --batch_size 8 \
  --optimizer sgd \
  --lr 5e-4 \
  --chip_size 400 \
  --save_epoch 201 \
  --n_epochs 200 \
  --historical

rm MS_DeepLab_resnet_trained_VOC.pth
rm -rf data/
tar -zcvf sentinel_unet-historical_trained.tar.gz results/
