# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
export MPLCONFIGDIR=$(pwd)
export SKIMAGE_DATADIR=$(pwd)
eval "$(conda shell.bash hook)"
conda activate /home/ksankaran/miniconda3/envs/lakes

# copy data over from staging
cp /staging/ksankaran/lakes/sentinel-2015.tar.gz .
cp /staging/ksankaran/lakes/MS_DeepLab_resnet_trained_VOC.pth .

# unzip transferred data
mkdir results data
tar -zxvf sentinel-2015.tar.gz
mv sentinel data/
tar -zxvf icimod.glacial-lakes-baselines.tar.gz

# clear unzipped data
rm sentinel-2015.tar.gz
rm icimod.glacial-lakes-baselines.tar.gz

# start training
python icimod.glacial-lakes-baselines/train.py \
  --experiment_name sentinel-delse \
  --loss delse \
  --model delse \
  --data_dir data/ \
  --dataset sentinel \
  --delse_pth MS_DeepLab_resnet_trained_VOC.pth \
  --save_dir results/save \
  --backup_dir results/backup \
  --log_dir results/logs \
  --batch_size 8 \
  --optimizer sgd \
  --lr 3e-4 \
  --delse_pretrain 3000 \
  --n_epochs 30

rm MS_DeepLab_resnet_trained_VOC.pth
tar -zcvf sentinel_delse_trained_full.tar.gz results/
