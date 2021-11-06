# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
export MPLCONFIGDIR=$(pwd)
export SKIMAGE_DATADIR=$(pwd)
eval "$(conda shell.bash hook)"
conda activate /home/ksankaran/miniconda3/envs/lakes

# copy data over from staging
mkdir results data
mkdir results/bing_test-snake
mkdir results/bing-snake
cp /staging/ksankaran/lakes/labels/GL_3basins_2015* data/
cp /staging/ksankaran/lakes/bing_processed_data.tar.gz data/

# unzip data and models
tar -zxvf icimod.glacial-lakes-baselines.tar.gz
cd data
tar -zxvf bing_processed_data.tar.gz
cd ..

for split_type in test val; do
  python icimod.glacial-lakes-baselines/inference_snake.py \
    --gl_filename data/GL_3basins_2015.shp \
    --input_dir data/bing/splits/${split_type}/images/ \
    --output_dir results/bing_${split_type}-snake/ \
    --overwrite \
    --image_source bing \
    --verbose

  python icimod.glacial-lakes-baselines/evaluate.py \
    --inference_dir results/bing_${split_type}-snake \
    --save_dir results/bing_${split_type}-snake \
    --grid 2 \
    --vector_label data/GL_3basins_2015.shp
done

# inference and evaluation overall
python icimod.glacial-lakes-baselines/inference_snake.py \
  --gl_filename data/GL_3basins_2015.shp \
  --input_dir data/bing/images/ \
  --output_dir results/bing-snake/ \
  --overwrite \
  --image_source bing \
  --verbose

python icimod.glacial-lakes-baselines/evaluate.py \
  --inference_dir results/bing-snake \
  --save_dir results/bing-snake \
  --grid 2 \
  --vector_label data/GL_3basins_2015.shp

rm icimod.glacial-lakes-baselines.tar.gz
rm -rf data/
tar -zcvf bing_snake_inference.tar.gz results/
