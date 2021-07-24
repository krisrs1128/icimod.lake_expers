# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
eval "$(conda shell.bash hook)"
conda activate /home/ksankaran/miniconda3/envs/lakes

# copy data over from staging
cp /staging/ksankaran/lakes/le7-2015.tar.gz . # change to bing_processed_data.tar.gz for bing
cp /staging/ksankaran/lakes/MS_DeepLab_resnet_trained_VOC.pth .

# unzip transferred data
mkdir results data
tar -zxvf le7-2015.tar.gz
mv le7-2015 data/
tar -zxvf icimod.glacial-lakes-baselines.tar.gz

# clear unzipped data
rm le7-2015.tar.gz
rm icimod.glacial-lakes-baselines.tar.gz

# start training
python icimod.glacial-lakes-baselines/train.py \
  --loss wbce \ # change to delse for delse model
  --data_dir data/ \
  --dataset landsat \ # change to "bing" for bing data
  --delse_pth MS_DeepLab_resnet_trained_VOC.pth \
  --save_dir results/save \
  --backup_dir results/backup \
  --batch_size 4 \
  --n_epochs 20

rm MS_DeepLab_resnet_trained_VOC.pth
tar -zcvf results.tar.gz results/
