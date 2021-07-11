mkdir results data

mv le7-2015-small.tar.gz data/
tar -zxvf data/le7-small.tar.gz
tar -zxvf icimod.glacial-lakes-baselines.tar.gz

python icimod.glacial-lakes-baselines/train.py --delse_pth MS_DeepLab_resnet_trained_VOC.pth --data_dir data/ --save_dir results/save --backup_dir results/backup
