# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
export MPLCONFIGDIR=$(pwd)
export SKIMAGE_DATADIR=$(pwd)
eval "$(conda shell.bash hook)"
conda activate /home/ksankaran/miniconda3/envs/lakes

# copy data over from staging
mkdir results data
cp /staging/ksankaran/lakes/labels/GL_3basins_2015* data/
cp /staging/ksankaran/lakes/bing_processed_data.tar.gz data/
cp /staging/ksankaran/lakes/MS_DeepLab_resnet_trained_VOC.pth .

# unzip data and models
tar -zxvf icimod.glacial-lakes-baselines.tar.gz
cd data
tar -zxvf bing_processed_data.tar.gz
cd ..

tar -zxvf trained_models.tar.gz
cd trained_models
tar -zxvf bing_delse_trained.tar.gz
mv results/backup/*.pth ../data/
cd ..

# perform inference
for split_type in test val; do
  python icimod.glacial-lakes-baselines/inference.py \
    --model delse \
    --data_dir data/bing/splits/${split_type} \
    --x_dir images \
    --meta_dir meta \
    --stats_fn statistics.csv \
    --model_pth data/bing-delse_best.pth \
    --inference_dir results/bing_${split_type}-delse/ \
    --dataset bing \
    --delse_pth MS_DeepLab_resnet_trained_VOC.pth
done

# inference overall
python icimod.glacial-lakes-baselines/inference.py \
  --model delse \
  --data_dir data/bing/ \
  --x_dir images \
  --meta_dir meta \
  --stats_fn statistics.csv \
  --model_pth data/bing-delse_best.pth \
  --inference_dir results/bing-delse/ \
  --dataset bing \
  --delse_pth MS_DeepLab_resnet_trained_VOC.pth

rm icimod.glacial-lakes-baselines.tar.gz MS_DeepLab_resnet_trained_VOC.pth
rm -rf data/
tar -zcvf bing_delse_inference.tar.gz results/
