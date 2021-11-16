# setup environment
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/ksankaran/miniconda3/envs/lakes/lib
export MPLCONFIGDIR=$(pwd)
export SKIMAGE_DATADIR=$(pwd)
eval "$(conda shell.bash hook)"
conda activate /anaconda/envs/lakes

# perform inference and evaluation on test set
for split_type in test val; do
  python icimod.glacial-lakes-baselines/inference.py \
    --data_dir /datadrive/glaciers/bing_glaciers/processed/bing/splits/${split_type} \
    --x_dir images \
    --meta_dir meta \
    --stats_fn statistics.csv \
    --model_pth /datadrive/results/backup/bing-unet_best.pth \
    --inference_dir /datadrive/results/inference/compressed/results/bing_${split_type}-unet

  python icimod.glacial-lakes-baselines/evaluate.py \
    --eval_paths /datadrive/results/inference/bing_${split_type}_paths.csv \
    --save_dir /datadrive/results/inference/compressed/results/bing_${split_type}-unet \
    --n_jobs 50 \
    --vector_label data/GL_3basins_2015.shp
done

# inference and evaluation overall
python icimod.glacial-lakes-baselines/inference.py \
  --data_dir /datadrive/glaciers/bing_glaciers/processed/bing/ \
  --x_dir images \
  --meta_dir meta \
  --stats_fn statistics.csv \
  --model_pth /datadrive/results/backup/bing-unet_best.pth \
  --inference_dir /datadrive/results/inference/compressed/results/bing-unet/

python icimod.glacial-lakes-baselines/evaluate.py \
  --save_dir /datadrive/results/inference/compressed/results/bing-unet \
  --n_jobs 50 \
  --eval_paths /datadrive/results/inference/bing_paths.csv \
  --vector_label /datadrive/snake/lakes/GL_3basins_2015.shp
