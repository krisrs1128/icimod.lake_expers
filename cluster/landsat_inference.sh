# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
eval "$(conda shell.bash hook)"
conda activate /home/ksankaran/miniconda3/envs/lakes

# copy data over from staging
cp /staging/ksankaran/lakes/le7-2015.tar.gz .
cp /staging/ksankaran/lakes/unet-landsat7-2.tar.gz .

# unzip data and models
mkdir results data
tar -zxvf le7-2015.tar.gz
tar -zxvf unet-landsat7-2.tar.gz
tar -zxvf icimod.glacial-lakes-baselines.tar.gz
mv le7-2015 data/

# clear up zipped files
rm le7-2015.tar.gz
rm unet-landsat7-2.tar.gz
rm icimod.glacial-lakes-baselines.tar.gz

# perform inference
python icimod.glacial-lakes-baselines/inference.py \
  --x_dir data/le7-2015/splits/val/images \
  --meta_dir data/le7-2015/splits/val/meta \
  --save_dir results/landsat-val \
  --model_pth unet-landsat7-2/bing_test_best.pth \
  --inference_dir results/landsat-val/

tar -zcvf results.tar.gz results/
