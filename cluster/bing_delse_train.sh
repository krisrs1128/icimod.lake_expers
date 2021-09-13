# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
export MPLCONFIGDIR=$(pwd)
export SKIMAGE_DATADIR=$(pwd)
eval "$(conda shell.bash hook)"
conda activate /home/ksankaran/miniconda3/envs/lakes

# copy data over from staging
cp /staging/ksankaran/lakes/bing_processed_data.tar.gz .
cp /staging/ksankaran/lakes/MS_DeepLab_resnet_trained_VOC.pth .

# unzip transferred data
mkdir results data
tar -zxvf bing_processed_data.tar.gz
mv bing/ data/
tar -zxvf icimod.glacial-lakes-baselines.tar.gz

# clear unzipped data
rm bing_processed_data.tar.gz
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
  --batch_size 3 \
  --optimizer sgd \
  --lr 3e-4 \
  --chip_size 400 \
  --delse_pretrain 3000 \
  --delse_iterations 2 \
  --save_epoch 41 \
  --n_epochs 40

rm MS_DeepLab_resnet_trained_VOC.pth
rm -rf data/
tar -zcvf bing_delse_trained.tar.gz results/
