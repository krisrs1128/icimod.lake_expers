
export INPUT_DIR=/datadrive/snake/lakes/sentinel-all/all/
export OUTPUT_DIR=/datadrive/snake/lakes/thumbnails/sentinel/

rm -rf $OUTPUT_DIR
mkdir -p $OUTPUT_DIR

for f in $(ls $INPUT_DIR/*2020*.tif); do
  gdal_translate -of PNG -b 3 -b 2 -b 1 $f $OUT_DIR/${$(basename f)%.tif}.png -outsize 50% 50%;
done;
