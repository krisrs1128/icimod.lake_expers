# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
eval "$(conda shell.bash hook)"
conda activate /home/ksankaran/miniconda3/envs/lakes

# unzip treansferred data
mkdir results data
mv le7-2015-small.tar.gz data/
tar -zxvf data/le7-small.tar.gz
tar -zxvf icimod.glacial-lakes-baselines.tar.gz

# start training
python icimod.glacial-lakes-baselines/train.py --delse_pth MS_DeepLab_resnet_trained_VOC.pth --data_dir data/ --save_dir results/save --backup_dir results/backup
