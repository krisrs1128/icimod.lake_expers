#!/bin/bash

for f in $(ls *prob*.tif); do
  export base=$(basename $f)
  export output=${base%.tif}.png
  gdal_translate -scale_1 0 1 -ot Byte -of PNG -b 1 $f $output -outsize 50% 50%;
  mv $output /mnt/blobfuse/lakes/metadata/bing/predictions/unet/
done;
