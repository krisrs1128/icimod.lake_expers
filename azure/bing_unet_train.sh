# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
export MPLCONFIGDIR=$(pwd)
export SKIMAGE_DATADIR=$(pwd)
eval "$(conda shell.bash hook)"
conda activate /anaconda/envs/lakes

CUDA_LAUNCH_BLOCKING=1 python icimod.glacial-lakes-baselines/train.py \
  --experiment_name bing-unet \
  --data_dir /datadrive/glaciers/bing_glaciers/processed \
  --dataset bing \
  --save_dir /datadrive/results/save \
  --backup_dir /datadrive/results/backup \
  --log_dir /datadrive/results/logs \
  --batch_size 8 \
  --divergence \
  --optimizer sgd \
  --lr 5e-4 \
  --chip_size 400 \
  --n_epochs 150
