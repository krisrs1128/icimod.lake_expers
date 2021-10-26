#!/bin/bash

input_dir=$1
output_dir=$2

rm -rf $output_dir
mkdir -p $output_dir

for f in $(ls $input_dir/*.tif); do
  export base=$(basename $f)
  export output=${base%.tif}.png
  gdal_translate -scale_1 0 1 -ot Byte -of PNG -b 1 $f $output -outsize 50% 50%;
  mv $output $output_dir/
done;
