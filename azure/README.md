
For processing the sentinel data, we can used

```
cd ~/icimod.glacial-lakes-baselines/utils
python preprocess.py --in_dir /datadrive/snake/lakes/sentinel/images/ --out_dir /datadrive/snake/lakes/sentinel/ # preprocess all years
python preprocess.py --split # expects all the 2015 & 2016 data in /datadrive/snake/lakes/sentinel-2015
```


```
cd ~/icimod.glacial-lakes-baselines/utils
python preprocess.py --in_dir /datadrive/glaciers/bing_glaciers/processed/bing/images --out_dir /datadrive/glaciers/bing_glaciers/processed/bing
python preprocess.py --split --in_dir /datadrive/glaciers/bing_glaciers/processed/bing/images --out_dir /datadrive/glaciers/bing_glaciers/processed/bing/splits
```

bash ~/icimod.lake_expers/transfer.sh . ../../results/bing_test-unet-png/

python evaluate.py --inference_dir /datadrive/results/inference/sentinel_test-snake.4/ --save_dir /datadrive/results/inference/sentinel_test-snake.4/ --vector_label /datadrive/snake/lakes/GL_3basins_2015.shp
python evaluate.py --inference_dir /datadrive/results/inference/sentinel_post-snake.4 --save_dir /datadrive/results/inference/sentinel_post-snake.4 --vector_label /datadrive/snake/lakes/GL_3basins_2015.shp

for f in $(ls *.tar.gz); do
  tar -zxvf $f;
done;

for f in $(ls -d /datadrive/results/inference/compressed/results/*sentinel*); do
  bash transfer.sh $f $f-images;
done;
