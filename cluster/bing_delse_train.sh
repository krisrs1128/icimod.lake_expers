# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
export MPLCONFIGDIR=$(pwd)
export SKIMAGE_DATADIR=$(pwd)
eval "$(conda shell.bash hook)"
conda activate /home/ksankaran/miniconda3/envs/lakes

# copy data over from staging
cp /staging/ksankaran/lakes/bing_glaciers_processed.tar.gz .
cp /staging/ksankaran/lakes/MS_DeepLab_resnet_trained_VOC.pth .

# unzip transferred data
mkdir results data
tar -zxvf bing_glaciers_processed.tar.gz
mv bing/ data/
tar -zxvf icimod.glacial-lakes-baselines.tar.gz

# clear unzipped data
rm bing_glaciers_processed.tar.gz
rm icimod.glacial-lakes-baselines.tar.gz

# start training
CUDA_LAUNCH_BLOCKING=1 python icimod.glacial-lakes-baselines/train.py \
  --experiment_name bing-delse \
  --loss delse \
  --model delse \
  --data_dir data/ \
  --dataset bing \
  --delse_pth MS_DeepLab_resnet_trained_VOC.pth \
  --save_dir results/save \
  --backup_dir results/backup \
  --log_dir results/logs \
  --batch_size 8 \
  --divergence \
  --n_epochs 20

rm MS_DeepLab_resnet_trained_VOC.pth
tar -zcvf bing_unet_trained.tar.gz results/
