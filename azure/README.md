
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
