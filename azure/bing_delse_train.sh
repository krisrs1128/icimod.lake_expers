# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
export MPLCONFIGDIR=$(pwd)
export SKIMAGE_DATADIR=$(pwd)
conda activate /anaconda/envs/lakes

# start training
CUDA_LAUNCH_BLOCKING=1 python icimod.glacial-lakes-baselines/train.py \
--experiment_name bing-delse \
--data_dir /datadrive/glaciers/bing_glaciers/processed \
--dataset bing \
--loss delse \
--model delse \
--delse_pth /datadrive/snake/models/MS_DeepLab_resnet_trained_VOC.pth \
--batch_size 4 \
--optimizer sgd \
--lr 3e-4 \
--chip_size 400 \
--delse_pretrain 8000 \
--delse_iterations 2 \
--save_epoch 3 \
--n_epochs 40
