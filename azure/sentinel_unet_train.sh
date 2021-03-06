# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
export MPLCONFIGDIR=$(pwd)
export SKIMAGE_DATADIR=$(pwd)
eval "$(conda shell.bash hook)"
conda activate /anaconda/envs/lakes

# start training
python icimod.glacial-lakes-baselines/train.py \
  --experiment_name sentinel-unet \
  --data_dir /datadrive/snake/lakes/ \
  --dataset sentinel \
  --delse_pth /datadrive/snake/models/MS_DeepLab_resnet_trained_VOC.pth \
  --save_dir /datadrive/results/save \
  --backup_dir /datadrive/results/backup \
  --log_dir /datadrive/results/logs \
  --batch_size 8 \
  --optimizer sgd \
  --lr 5e-4 \
  --chip_size 400 \
  --save_epoch 25 \
  --n_epochs 150
