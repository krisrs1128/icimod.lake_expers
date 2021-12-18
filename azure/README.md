
For processing the sentinel and bing data, we can use

```
cd ~/icimod.glacial-lakes-baselines/utils
python preprocess.py --split # expects all the 2015 & 2016 data in /datadrive/snake/lakes/sentinel-2015
python preprocess.py --in_dir /datadrive/snake/lakes/sentinel/images/ --out_dir /datadrive/snake/lakes/sentinel/ # preprocess all years
python preprocess.py --in_dir /datadrive/glaciers/bing_glaciers/processed/bing/images --out_dir /datadrive/glaciers/bing_glaciers/processed/bing
python preprocess.py --split --in_dir /datadrive/glaciers/bing_glaciers/processed/bing/images --out_dir /datadrive/glaciers/bing_glaciers/processed/bing/splits
```

This can be used to unzip a collection of zipped files.
```
for f in $(ls *.tar.gz); do
  tar -zxvf $f;
done;

# same for zipping
for f in $(ls -d *); do
  tar -zcvf $f.tar.gz $f;
done;
```

This creates png images corresponding to all the tif imagery in a set of
directories.
```
for f in $(ls -d /datadrive/results/inference/compressed/results/*); do
  bash transfer.sh $f $f-images;
done;
```

To generate csv files containing paths on which to perform evaluation, we can
use the following,

```
cd icimod.glacial-lakes-baselines

# paths for bing models
for model in unet unet-historical delse delse-historical; do
  python -m utils.inference_paths \
     --inference_dir /datadrive/results/inference/compressed/results/bing-${model} \
     --dataset bing \
     --mode prob \
     --model ${model}
done;

# paths for sentinel models
for model in unet unet-historical delse delse-historical; do
  python -m utils.inference_paths \
     --image_dir /datadrive/snake/lakes/sentinel/ \
     --inference_dir /datadrive/results/inference/compressed/results/sentinel-${model} \
     --labeling_dir /datadrive/snake/lakes/labeling/ \
     --dataset sentinel \
     --mode prob \
     --model ${model}
done;
```

Here are some commands to run model evaluation on already computed inferences.
```
for model in unet unet-historical delse delse-historical; do
  for dataset in bing sentinel; do
    bash icimod.lake_expers/azure/eval.sh $model $dataset
  done;
done;

# different process for snake
python evaluate.py --inference_dir /datadrive/results/inference/sentinel_test-snake.4/ --save_dir /datadrive/results/inference/sentinel_test-snake.4/ --vector_label /datadrive/snake/lakes/GL_3basins_2015.shp
python evaluate.py --inference_dir /datadrive/results/inference/sentinel_post-snake.4 --save_dir /datadrive/results/inference/sentinel_post-snake.4 --vector_label /datadrive/snake/lakes/GL_3basins_2015.shp
```
