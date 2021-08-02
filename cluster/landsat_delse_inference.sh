# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
export MPLCONFIGDIR=$(pwd)
export SKIMAGE_DATADIR=$(pwd)
eval "$(conda shell.bash hook)"
conda activate /home/ksankaran/miniconda3/envs/lakes

# copy data over from staging
mkdir results data
cp /staging/ksankaran/lakes/labels/GL_3basins_2015* data/
cp /staging/ksankaran/lakes/le7-2015.tar.gz data/
cp /staging/ksankaran/lakes/data/
cp /staging/ksankaran/lakes/MS_DeepLab_resnet_trained_VOC.pth .
cp /staging/ksankaran/lakes/trained_models/landsat7-delse_best.pth data/

# unzip data and models
tar -zxvf icimod.glacial-lakes-baselines.tar.gz
cd data
tar -zxvf le7-2015.tar.gz
cd ..

# perform inference
python icimod.glacial-lakes-baselines/inference.py \
  --model delse \
  --data_dir data/le7-2015/splits/val \
  --x_dir images \
  --meta_dir meta \
  --stats_fn statistics.csv \
  --model_pth data/landsat7-delse_best.pth \
  --inference_dir results/landsat_val-delse/ \
  --delse_pth MS_DeepLab_resnet_trained_VOC.pth

python icimod.glacial-lakes-baselines/evaluate.py \
  --inference_dir results/landsat_val-delse \
  --save_dir results/landsat_val-delse \
  --vector_label data/GL_3basins_2015.shp

rm icimod.glacial-lakes-baselines.tar.gz MS_DeepLab_resnet_trained_VOC.pth
tar -zcvf landsat_delse_inference.tar.gz results/
